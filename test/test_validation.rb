$VERBOSE = true
require_relative 'test_helper'

class TestValidationFunctionalCondition < Test::Unit::TestCase
  class Sthlambda
    include Validation
    
    def lanks
      1..20
    end
    
    attr_validator :lank, ->lank{lanks.include? lank}
  end
  
  def test_lambda
    sth = Sthlambda.new
    sth.lank = 2
    assert_equal 2, sth.lank
    
    assert_raises Validation::InvalidWritingError do
      sth.lank = 31
    end
  end
  
  class SthProc
    include Validation
    
    attr_validator :lank, Proc.new{|n|(3..9) === n}
  end

  def test_Proc
    sth = SthProc.new
    sth.lank = 8
    assert_equal 8, sth.lank
    
    assert_raises Validation::InvalidWritingError do
      sth.lank = 2
    end
  end
  
  class SthMethod
    include Validation
    
    attr_validator :lank, 7.method(:<)
  end
  
  def test_Method
    sth = SthMethod.new
    sth.lank = 8
    assert_equal 8, sth.lank
    
    assert_raises Validation::InvalidWritingError do
      sth.lank = 6
    end
  end
end

class TestValidationSpecificConditions < Test::Unit::TestCase
  class Sth
    include Validation

    attr_validator :list_only_int, GENERICS(Integer)
    attr_validator :true_or_false, BOOL?
    attr_validator :like_str, STRINGABLE?
    attr_validator :has_foo, CAN(:foo)
    attr_validator :has_foo_and_bar, CAN(:foo, :bar)
    attr_validator :one_of_member, MEMBER_OF([1, 3])
    attr_validator :has_ignore, AND(1..5, 3..10)
    attr_validator :nand, NAND(1..5, 3..10)
    attr_validator :all_pass, OR(1..5, 3..10)
    attr_validator :catch_error, CATCH(NoMethodError){|v|v.no_name!}
    attr_validator :rescue_error, RESCUE(NameError){|v|v.no_name!}
    attr_validator :no_exception, QUIET(->v{v.class})
    attr_validator :not_integer, NOT(Integer)
  end

  def test_not
    sth = Sth.new
    
    obj = Object.new
    
    sth.not_integer = obj
    assert_same obj, sth.not_integer

    assert_raises Validation::InvalidWritingError do
      sth.not_integer = 1
    end
  end

  def test_quiet
    sth = Sth.new
    
    obj = Object.new
    
    sth.no_exception = obj
    assert_same obj, sth.no_exception
    sth.no_exception = false

    obj.singleton_class.class_eval do
      undef_method :class
    end

    assert_raises Validation::InvalidWritingError do
      sth.no_exception = obj
    end
  end

  def test_catch
    sth = Sth.new
    
    obj = Object.new
    
    sth.catch_error = obj
    assert_same obj, sth.catch_error
    sth.catch_error = false

    obj.singleton_class.class_eval do
      def no_name!
      end
    end

    assert_raises Validation::InvalidWritingError do
      sth.catch_error = obj
    end
    
    obj.singleton_class.class_eval do
      remove_method :no_name!
      
      def no_name!
        raise NameError
      end
    end
  
    assert_raises Validation::InvalidWritingError do
      sth.catch_error = obj
    end
  end

  def test_rescue
    sth = Sth.new
    
    obj = Object.new
    
    sth.rescue_error = obj
    assert_same obj, sth.rescue_error
    sth.rescue_error = false

    obj.singleton_class.class_eval do
      def no_name!
      end
    end

    assert_raises Validation::InvalidWritingError do
      sth.rescue_error = obj
    end
    
    obj.singleton_class.class_eval do
      remove_method :no_name!
      
      def no_name!
        raise NameError
      end
    end
  
    sth.rescue_error = obj
  end

  def test_or
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.all_pass = 11
    end
    
    sth.all_pass = 1
    assert_equal 1, sth.all_pass
    sth.all_pass = 4
    assert_equal 4, sth.all_pass
  end

  def test_and
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = 1
    end

    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = 2
    end
  
    sth.has_ignore = 3
    assert_equal 3, sth.has_ignore
    assert_raises Validation::InvalidWritingError do
      sth.has_ignore = []
    end
  end

  def test_nand
    sth = Sth.new

    assert_raises Validation::InvalidWritingError do
      sth.nand = 4
    end

    assert_raises Validation::InvalidWritingError do
      sth.nand = 4.5
    end
  
    sth.nand = 2
    assert_equal 2, sth.nand
    sth.nand = []
    assert_equal [], sth.nand
  end

  def test_member_of
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.one_of_member = 4
    end
  
    sth.one_of_member = 3
    assert_equal 3, sth.one_of_member
  end
  
  def test_generics
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.list_only_int = [1, '2']
    end
  
    sth.list_only_int = [1, 2]
    assert_equal [1, 2], sth.list_only_int
    sth.list_only_int = []
    assert_equal [], sth.list_only_int
  end
  
  def test_boolean
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.true_or_false = nil
    end
 
    sth.true_or_false = true
    assert_equal true, sth.true_or_false
    sth.true_or_false = false
    assert_equal false, sth.true_or_false
  end
  
  def test_STRINGABLE?
    sth = Sth.new
    obj = Object.new
    
    assert_raises Validation::InvalidWritingError do
      sth.like_str = obj
    end
  
    obj.singleton_class.class_eval do
      def to_str
      end
    end
  end

  def test_responsible_arg1
    sth = Sth.new
    obj = Object.new
    
    raise if obj.respond_to? :foo

    assert_raises Validation::InvalidWritingError do
      sth.has_foo = obj
    end
    
    obj.singleton_class.class_eval do
      def foo
      end
    end

    raise unless obj.respond_to? :foo
    
    sth.has_foo = obj
    assert_equal obj, sth.has_foo
  end

  def test_responsible_arg2
    sth = Sth.new
    obj = Object.new

    raise if obj.respond_to? :foo
    raise if obj.respond_to? :bar

    assert_raises Validation::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end
    
    obj.singleton_class.class_eval do
      def foo
      end
    end
    
    raise unless obj.respond_to? :foo

    assert_raises Validation::InvalidWritingError do
      sth.has_foo_and_bar = obj
    end
    
    obj.singleton_class.class_eval do
      def bar
      end
    end

    raise unless obj.respond_to? :bar
    
    sth.has_foo_and_bar = obj
    assert_equal obj, sth.has_foo_and_bar
  end
end

class TestGetterValidation < Test::Unit::TestCase
  class Sth
    include Validation
    
    attr_validator :plus_getter, /./, writer_validation: true, reader_validation: true
    attr_validator :only_getter, /./, writer_validation: false, reader_validation: true
  end
  
  def test_writer_validation
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.plus_getter = ''
    end
    
    sth.plus_getter = 'abc'
    assert_equal 'abc', sth.plus_getter
    sth.plus_getter.clear
    
    assert_raises Validation::InvalidReadingError do
      sth.plus_getter
    end
    
    sth.only_getter = ''
    
    assert_raises Validation::InvalidReadingError do
      sth.only_getter
    end
  end
end

class TestValidationAdjustmentOld < Test::Unit::TestCase
  class Sth
    include Validation
    
    attr_validator :age, Numeric, &->arg{Integer arg}
  end
  
  def setup
    @sth = Sth.new
    assert_same nil, @sth.age
  end
  
  def test_procedure
    @sth.age = 10
    assert_same 10, @sth.age
    @sth.age = 10.0
    assert_same 10, @sth.age

    assert_raises Validation::InvalidAdjustingError do
      @sth.age = '10.0'
    end
    
    @sth.age = '10'
    assert_same 10, @sth.age
  end
end

class TestValidationAdjustment < Test::Unit::TestCase
  class MyClass
    def self.parse(v)
      raise unless /\A[a-z]+\z/ =~ v
      new
    end
  end
  
  class Sth
    include Validation

    attr_validator :chomped, AND(Symbol, NOT(/\n/)), &WHEN(String, ->v{v.chomp!.to_sym})
    attr_validator :no_reduced, Symbol, &->v{v.to_sym}
    attr_validator :reduced, Symbol, &INJECT(->v{v.to_s}, ->v{v.to_sym})
    attr_validator :integer, Integer, &PARSE(Integer)
    attr_validator :myobj, ->v{v.instance_of? MyClass}, &PARSE(MyClass)
  end
  
  def test_WHEN
    sth = Sth.new
    
    assert_raises Validation::InvalidWritingError do
      sth.chomped = :"a\n"
    end
    
    assert_raises Validation::InvalidAdjustingError do
      sth.chomped = 'a'
    end

    sth.chomped = :a
    
    assert_equal :a, sth.chomped
    
    sth.chomped = :b
    assert_equal :b, sth.chomped
  end

  def test_REDUCE
    sth = Sth.new
    
    assert_raises Validation::InvalidAdjustingError do
      sth.no_reduced = 1
    end
    
    sth.reduced = 1
    
    assert_equal :'1', sth.reduced
  end
  
  def test_PARSE
    sth = Sth.new
    
    assert_raises Validation::InvalidAdjustingError do
      sth.integer = '1.0'
    end
    
    sth.integer = '1'
    
    assert_equal 1, sth.integer
    
    assert_raises Validation::InvalidAdjustingError do
      sth.myobj = '1'
    end
    
    sth.myobj = 'a'
    
    assert_kind_of MyClass, sth.myobj
  end
end
