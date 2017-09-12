using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;
using System.IO;

public class LuaManager : Singleton<LuaManager> {
    public LuaEnv luaEnv;

    [CSharpCallLua]
    public delegate void LuaUpdate();
    LuaUpdate lfUpdate;

    [CSharpCallLua]
    public delegate void LuaFixedupdate();
    LuaFixedupdate lfFixedupdate;

    [CSharpCallLua]
    public delegate void LuaProcessMsg(string msg);
    LuaProcessMsg lfProcessMsg;

    byte[] load(ref string filepath) {
        filepath = filepath.Replace('.', '/');
        string realPath = Path.Combine(Application.dataPath, "LuaScripts/" + filepath + ".lua");
        if (File.Exists(realPath)) {
            return File.ReadAllBytes(realPath);
        } else {
            return null;
        }
    }

    public void Init() {
        luaEnv = new LuaEnv();

        luaEnv.AddLoader(load);

        DoLua("bootstrap");

        object[] rtns = DoLua("game");
        if (rtns == null) {
            return;
        }

        LuaTable entry = rtns[0] as LuaTable;
        entry.Get("update", out lfUpdate);
        entry.Get("fixedUpdate", out lfFixedupdate);
        entry.Get("processMsg", out lfProcessMsg);
    }

    public object[] DoLua(string name, string chunk = "chunk", LuaTable env = null) {
        byte[] bt = load(ref name);
        if (bt == null) {
            return null;
        }

        return luaEnv.DoString(bt, chunk, env);
    }

    public LuaEnv GetEnv() {
        return luaEnv;
    }

    public void Update() {
        if (lfUpdate != null) {
            lfUpdate();
        }
    }

    public void FixedUpdate() {
        if (lfFixedupdate != null) {
            lfFixedupdate();
        }
    }

    public void ProcessMsg(string msg) {
        if (lfProcessMsg != null) {
            lfProcessMsg(msg);
        }
    }
}
