#if USE_UNI_LUA
using LuaAPI = UniLua.Lua;
using RealStatePtr = UniLua.ILuaState;
using LuaCSFunction = UniLua.CSharpFunctionDelegate;
#else
using LuaAPI = XLua.LuaDLL.Lua;
using RealStatePtr = System.IntPtr;
using LuaCSFunction = XLua.LuaDLL.lua_CSFunction;
#endif

using System;


namespace XLua
{
    public partial class DelegateBridge : DelegateBridgeBase
    {
		
		public void __Gen_Delegate_Imp0()
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                
                int __gen_error = LuaAPI.lua_pcall(L, 0, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public void __Gen_Delegate_Imp1(string p0)
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.lua_pushstring(L, p0);
                
                int __gen_error = LuaAPI.lua_pcall(L, 1, 0, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                
                LuaAPI.lua_settop(L, err_func - 1);
                
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public int __Gen_Delegate_Imp2(int p0, string p1, out CSCallLua.DClass p2)
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                LuaAPI.xlua_pushinteger(L, p0);
                LuaAPI.lua_pushstring(L, p1);
                
                int __gen_error = LuaAPI.lua_pcall(L, 2, 2, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                p2 = (CSCallLua.DClass)translator.GetObject(L, err_func + 2, typeof(CSCallLua.DClass));
                
                int __gen_ret = LuaAPI.xlua_tointeger(L, err_func + 1);
                LuaAPI.lua_settop(L, err_func - 1);
                return  __gen_ret;
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
		public System.Action __Gen_Delegate_Imp3()
		{
#if THREAD_SAFT || HOTFIX_ENABLE
            lock (luaEnv.luaEnvLock)
            {
#endif
                RealStatePtr L = luaEnv.rawL;
                int err_func =LuaAPI.load_error_func(L, errorFuncRef);
                ObjectTranslator translator = luaEnv.translator;
                
                LuaAPI.lua_getref(L, luaReference);
                
                
                int __gen_error = LuaAPI.lua_pcall(L, 0, 1, err_func);
                if (__gen_error != 0)
                    luaEnv.ThrowExceptionFromError(err_func - 1);
                
                
                System.Action __gen_ret = translator.GetDelegate<System.Action>(L, err_func + 1);
                LuaAPI.lua_settop(L, err_func - 1);
                return  __gen_ret;
#if THREAD_SAFT || HOTFIX_ENABLE
            }
#endif
		}
        
        
		static DelegateBridge()
		{
		    Gen_Flag = true;
		}
		
		public override Delegate GetDelegateByType(Type type)
		{
		
		    if (type == typeof(LuaBehaviour.Action))
			{
			    return new LuaBehaviour.Action(__Gen_Delegate_Imp0);
			}
		
		    if (type == typeof(LuaManager.LuaUpdate))
			{
			    return new LuaManager.LuaUpdate(__Gen_Delegate_Imp0);
			}
		
		    if (type == typeof(LuaManager.LuaFixedupdate))
			{
			    return new LuaManager.LuaFixedupdate(__Gen_Delegate_Imp0);
			}
		
		    if (type == typeof(LuaManager.LuaProcessMsg))
			{
			    return new LuaManager.LuaProcessMsg(__Gen_Delegate_Imp1);
			}
		
		    if (type == typeof(CSCallLua.FDelegate))
			{
			    return new CSCallLua.FDelegate(__Gen_Delegate_Imp2);
			}
		
		    if (type == typeof(CSCallLua.GetE))
			{
			    return new CSCallLua.GetE(__Gen_Delegate_Imp3);
			}
		
		    throw new InvalidCastException("This delegate must add to CSharpCallLua: " + type);
		}
	}
    
    
}