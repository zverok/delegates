# frozen_string_literal: true

require 'rspec/its'
require 'saharspec'
require 'delegates'

RSpec.describe Delegates do
  RSpec::Matchers.define :provide do |**attrs|
    match do |block|
      result = block.call
      expect(result).to have_attributes(**attrs)
    end

    supports_block_expectations
  end

  RSpec::Matchers.define :provide_failing do |**errs|
    match do |block|
      result = block.call
      errs.each do |method, error|
        expect { result.send(method) }.to raise_error(*error)
      end
    end

    supports_block_expectations
  end

  subject(:delegator) {
    proc { |*methods, **params|
      Struct.new(:name, :place, :age, :case) {
        extend Delegates

        def self.table_name
          'some_table'
        end

        def initialize(*)
          super
          @ivar = 111
        end

        # method with side-effects, should be called only once per delegation
        def item
          @items ||= [1]
          @items.shift # rubocop:disable RSpec/InstanceVariable
        end

        delegate(*methods, **params)
      }.new(*args)
    }
  }

  let(:place) { Struct.new(:street, :city) }
  let(:args) { ['Victor', place.new('Oleksiivska', 'Kharkiv'), nil, '#123'] }

  its_call(:street, :city, to: :place) {
    is_expected.to provide(city: 'Kharkiv', street: 'Oleksiivska')
  }

  its_call(:street, to: :place, prefix: true) {
    is_expected.to provide(place_street: 'Oleksiivska')
  }

  its_call(:street, to: :place, prefix: 'city') {
    is_expected.to provide(city_street: 'Oleksiivska')
  }

  its_call(:upcase, to: :name, prefix: true, allow_nil: true) {
    is_expected.to provide(name_upcase: 'VICTOR')
  }

  its_call(:floor, to: :age, prefix: true, allow_nil: true) {
    is_expected.to provide(age_floor: nil)
  }

  its_call(:to_f, to: :age, prefix: true, allow_nil: true) {
    is_expected.to provide(age_to_f: 0.0)
  }

  its_call(:floor, to: :age, prefix: true) {
    is_expected.to provide_failing(age_floor: [Delegates::DelegationError, /delegated to age\.floor, but age is nil/])
  }

  its_call(:length, to: :case, prefix: true) {
    is_expected.to provide(case_length: 4)
  }

  its_call(:table_name, to: :class) {
    is_expected.to provide(table_name: 'some_table')
  }

  its_call(:table_name, to: :class, prefix: true) {
    is_expected.to provide(class_table_name: 'some_table')
  }

  its_call(:upcase, to: 'place.city') {
    is_expected.to provide(upcase: 'KHARKIV')
  }

  its_call(:foo, to: :place) {
    is_expected.to provide_failing(foo: NoMethodError)
  }

  its_call(:to_f, to: :item) {
    is_expected.to provide(to_f: 1.0)
  }

  its_call(:to_f, to: :@ivar) {
    is_expected.to provide(to_f: 111.0)
  }

  its_call(:to_f, to: :@ivar, prefix: true) {
    is_expected.to raise_error ArgumentError, /when delegating to a method/
  }

  context 'when methods have arguments' do
    subject(:object) { delegator.call(:street=, to: :place) }

    it {
      expect { object.street = 'Peremohy' }.to change { object.place.street }.to 'Peremohy'
    }
  end
end
