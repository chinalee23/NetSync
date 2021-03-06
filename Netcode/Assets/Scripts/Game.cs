﻿using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using UnityEngine.SceneManagement;

public class Game : MonoBehaviour {
    public float NetDelay = 0f;

    public static Game Instance() {
        return inst;
    }
    private static Game inst;

	void Awake() {
        inst = this;

        Application.runInBackground = true;

        init();

        DontDestroyOnLoad(gameObject);
    }

	void Start () {
        LuaManager.Instance().Start();
	}
		
	void Update () {
        LuaManager.Instance().Update();
        NetSystem.Instance().Update();
	}

    void FixedUpdate() {
        LuaManager.Instance().FixedUpdate();
    }

    void init() {
        LuaManager.Instance().Init();
    }

    void OnApplicationQuit() {
        NetSystem.Instance().Close();
    }
}
