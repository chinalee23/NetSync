using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class ResourcesMgr {
    public static GameObject LoadPrefab(string path) {
        UnityEngine.Object o = Resources.Load(path);
        if (o == null) {
            return null;
        }

        GameObject go = MonoBehaviour.Instantiate(o) as GameObject;
        return go;
    }
}
