package states;

#if test_flag
#error "Cannot use CompileFlagTestState when test_flag is defined"
#end
#if test_flag
import misc.ThrowsCompileError;
#end

class CompileFlagTestState extends FlxState {}