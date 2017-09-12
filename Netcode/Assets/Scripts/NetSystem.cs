using System.Collections;
using System.Collections.Generic;
using UnityEngine;
using System.Net;
using System.IO;
using System;
using System.Net.Sockets;


class Buffer {
    public byte[] bt;
    public int len;

    public Buffer() {
        bt = new byte[1024];
        len = 0;
    }
}

public class NetSystem : Singleton<NetSystem> {
    TcpClient client;
    NetworkStream stream;
    object _lock = new object();

    Buffer bufferSocket = new Buffer();
    List<string> bufferMsg = new List<string>();

    void readCallback(IAsyncResult ar) {
        lock (_lock) {
            int len = stream.EndRead(ar);
            if (len < 0) {
                Debug.LogError("connect lose");
                return;
            }
            byte[] bt = new byte[len];
            Array.Copy(bufferSocket.bt, 0, bt, 0, len);
            string msg = System.Text.Encoding.UTF8.GetString(bt);
            bufferMsg.Add(msg);

            stream.BeginRead(bufferSocket.bt, 0, bufferSocket.bt.Length, readCallback, null);
        }
    }

    void processMsg() {
        lock (_lock) {
            for (int i = 0; i < bufferMsg.Count; ++i) {
                LuaManager.Instance().ProcessMsg(bufferMsg[i]);
            }
            bufferMsg.Clear();
        }
    }

    void send(string msg) {
        if (stream == null) {
            return;
        }
        byte[] data = System.Text.Encoding.UTF8.GetBytes(msg);
        stream.Write(data, 0, data.Length);
    }

    IEnumerator delaySend(string msg) {
        yield return new WaitForSeconds(Game.Instance().NetDelay);
        send(msg);
    }

    public void Init() {
        try {
            client = new TcpClient("192.168.142.128", 12345);
            if (client.Connected) {
                Debug.Log("connect success");
                stream = client.GetStream();
                stream.BeginRead(bufferSocket.bt, 0, bufferSocket.bt.Length, readCallback, null);
            } else {
                Debug.LogError("connect fail");
            }
        } catch (Exception e) {
            Debug.LogError("net init fail: " + e.ToString());
        }
    }

    public void Send(string msg) {
        if (Game.Instance().NetDelay > 0) {
            Game.Instance().StartCoroutine(delaySend(msg));
        } else {
            send(msg);
        }
    }

    public void Update() {
        processMsg();
    }

    public void Close() {
        if (client != null) {
            client.Close();
        }
    }
}
