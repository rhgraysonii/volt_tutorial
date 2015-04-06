require 'lib/spec_helper'

describe Opal::Compiler do
  describe 'requiring' do
    it 'calls #require' do
      expect_compiled("require 'pippo'").to include('self.$require("pippo")')
    end
  end

  describe 'requirable' do
    it 'executes the file' do
      expect_compiled("").to include('(function(Opal) {')
      expect_compiled("").to end_with("})(Opal);\n")
    end

    it 'puts the compiled into "Opal.modules"' do
      options = { :requirable => true, :file => "pippo" }
      expect_compiled("", options).to include('Opal.modules["pippo"] = function(Opal) {')
      expect_compiled("", options).to end_with("};\n")
    end
  end

  it "should compile simple ruby values" do
    expect_compiled("3.142").to include("return 3.142")
    expect_compiled("123e1").to include("return 1230")
    expect_compiled("123E+10").to include("return 1230000000000")
    expect_compiled("false").to include("return false")
    expect_compiled("true").to include("return true")
    expect_compiled("nil").to include("return nil")
  end

  it "should compile ruby strings" do
    expect_compiled('"hello world"').to include('return "hello world"')
    expect_compiled('"hello #{100}"').to include('"hello "', '100')
  end

  it "should compile method calls" do
    expect_compiled("self.inspect").to include("$inspect()")
    expect_compiled("self.map { |a| a + 10 }").to include("$map")
  end

  it "should compile constant lookups" do
    expect_compiled("Object").to include("Object")
    expect_compiled("Array").to include("Array")
  end

  describe "class names" do
    it "generates a named function for class using $ prefix" do
      expect_compiled("class Foo; end").to include("function $Foo")
    end
  end

  describe "debugger special method" do
    it "generates debugger keyword in javascript" do
      expect_compiled("debugger").to include("debugger")
      expect_compiled("debugger").to_not include("$debugger")
    end
  end

  describe "DATA special variable" do
    it "is not a special case unless __END__ part present in source" do
      expect_compiled("DATA").to include("DATA")
      expect_compiled("DATA\n__END__").to_not include("DATA")
    end

    it "DATA gets compiled as a reference to special $__END__ variable" do
      expect_compiled("a = DATA\n__END__").to include("a = $__END__")
    end

    it "causes the compiler to create a reference to special __END__ variable" do
      expect_compiled("DATA\n__END__\nFord Perfect").to include("$__END__ = ")
    end

    it "does not create a reference to __END__ vairbale unless __END__ content present" do
      expect_compiled("DATA").to_not include("$__END__ = ")
    end
  end

  describe "escapes in x-strings" do
    it "compiles the exscapes directly as appearing in x-strings" do
      expect_compiled('`"hello\nworld"`').to include('"hello\nworld"')
      expect_compiled('%x{"hello\nworld"}').to include('"hello\nworld"')
    end
  end

    describe 'pre-processing require-ish methods' do
    describe '#require' do
      it 'parses and resolve #require argument' do
        compiler = compiler_for(%Q{require "#{__FILE__}"})
        expect(compiler.requires).to eq([__FILE__])
      end
    end

    describe '#autoload' do
      it 'ignores autoload outside of context class' do
        compiler = compiler_for(%Q{autoload Whatever, "#{__FILE__}"})
        expect(compiler.requires).to eq([])
      end

      it 'parses and resolve second #autoload arguments' do
        compiler = compiler_for(%Q{class Foo; autoload Whatever, "#{__FILE__}"; end})
        expect(compiler.requires).to eq([__FILE__])
      end
    end

    describe '#require_relative' do
      it 'parses and resolve #require_relative argument' do
        compiler = compiler_for(%Q{require_relative "./#{File.basename(__FILE__)}"}, file: __FILE__)
        expect(compiler.requires).to eq([__FILE__])
      end
    end

    describe '#require_tree' do
      require 'pathname'
      let(:file) { Pathname(__FILE__).join('../fixtures/require_tree_test.rb') }

      it 'parses and resolve #require argument' do
        compiler = compiler_for(file.read)
        expect(compiler.required_trees).to eq(['../fixtures/required_tree_test'])
      end
    end
  end

  def expect_compiled(*args)
    expect(Opal::Compiler.new(*args).compile)
  end

  def compiler_for(*args)
    Opal::Compiler.new(*args).tap(&:compile)
  end
end
