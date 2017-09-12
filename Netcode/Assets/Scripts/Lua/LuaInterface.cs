using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using XLua;

[LuaCallCSharp]
public class LuaInterface {
    public static void SetScale(GameObject go, float x, float y, float z) {
        go.transform.localScale = new Vector3(x, y, z);
    }

    public static void SetScale(Transform trans, float x, float y, float z) {
        trans.localScale = new Vector3(x, y, z);
    }

    public static void SetRotationByEuler(GameObject go, float x, float y, float z) {
        go.transform.rotation = Quaternion.Euler(new Vector3(x, y, z));
    }

    public static void SetRotationByEuler(Transform trans, float x, float y, float z) {
        trans.rotation = Quaternion.Euler(new Vector3(x, y, z));
    }

    public static void SetPosition(GameObject go, float x, float y, float z) {
        go.transform.position = new Vector3(x, y, z);
    }

    public static void SetPosition(Transform trans, float x, float y, float z) {
        trans.position = new Vector3(x, y, z);
    }

    public static void PlayAnimation(GameObject go, string name) {
        Animation anim = go.GetComponent<Animation>();
        if (anim != null) {
            anim.Play(name);
        }
    }

    public static void Connect() {
        NetSystem.Instance().Init();
    }

    public static void SendMsg(string msg) {
        NetSystem.Instance().Send(msg);
    }

    public static void LoadScene(string name) {
        UnityEngine.SceneManagement.SceneManager.LoadScene(name);
    }
}
