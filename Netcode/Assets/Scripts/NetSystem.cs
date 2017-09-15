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

            int offset = 0;
            while (offset < len) {
                int length = IPAddress.NetworkToHostOrder(BitConverter.ToInt32(bufferSocket.bt, offset));
                if ((offset + length) > len) {
                    break;
                }
                byte[] bt = new byte[length - 4];
                Array.Copy(bufferSocket.bt, offset + 4, bt, 0, length - 4);
                string msg = System.Text.Encoding.UTF8.GetString(bt);
                bufferMsg.Add(msg);

                offset += length;
            }

            int lenLeft = len - offset;
            Array.Copy(bufferSocket.bt, offset, bufferSocket.bt, 0, lenLeft);

            stream.BeginRead(bufferSocket.bt, lenLeft, bufferSocket.bt.Length - lenLeft, readCallback, null);
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
        byte[] btLen = BitConverter.GetBytes(IPAddress.HostToNetworkOrder(data.Length + 4));
        byte[] btMsg = new byte[data.Length + 4];
        Array.Copy(btLen, 0, btMsg, 0, 4);
        Array.Copy(data, 0, btMsg, 4, data.Length);
        stream.Write(btMsg, 0, data.Length + 4);
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
