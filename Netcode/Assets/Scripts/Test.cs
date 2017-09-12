using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class Test : MonoBehaviour {

    enum Direction {
        None,
        Up,
        Down,
        Left,
        Right,
    }

    public Camera camera;
    public GameObject character;

    Vector3 cameraOffset;
    Direction newDirect;
    Direction oldDirect;
    Animation anim;
    float speed = 10;
    float INTERVAL = 0.02f;

	// Use this for initialization
	void Start () {
        cameraOffset = camera.transform.position;

        anim = character.GetComponent<Animation>();
        anim.Play("idle");

        newDirect = Direction.None;
        oldDirect = Direction.None;
    }
	
	// Update is called once per frame
	void Update () {
        updateCamera();
        updateInput();
	}

    void FixedUpdate() {
        if (newDirect == Direction.None) {
            if (oldDirect != Direction.None) {
                anim.Play("idle");
                oldDirect = Direction.None;
            }
        } else {
            if (oldDirect == Direction.None) {
                anim.Play("run");
            }
            if (oldDirect != newDirect) {
                switch (newDirect) {
                    case Direction.Up:
                        character.transform.rotation = Quaternion.Euler(Vector3.zero);
                        break;
                    case Direction.Down:
                        character.transform.rotation = Quaternion.Euler(Vector3.up * 180);
                        break;
                    case Direction.Left:
                        character.transform.rotation = Quaternion.Euler(Vector3.up * 270);
                        break;
                    case Direction.Right:
                        character.transform.rotation = Quaternion.Euler(Vector3.up * 90);
                        break;
                }
                oldDirect = newDirect;
            }
        }

        if (oldDirect != Direction.None) {
            float dist = speed * INTERVAL;
            Vector3 offset = Vector3.zero;
            switch (oldDirect) {
                case Direction.Left:
                    offset = Vector3.left;
                    break;
                case Direction.Right:
                    offset = Vector3.right;
                    break;
                case Direction.Up:
                    offset = Vector3.forward;
                    break;
                case Direction.Down:
                    offset = Vector3.back;
                    break;
            }
            character.transform.position += offset * dist;
        }
    }

    void updateInput() {
        if (Input.GetKeyDown(KeyCode.LeftArrow)) {
            newDirect = Direction.Left;
        } else if (Input.GetKeyDown(KeyCode.RightArrow)) {
            newDirect = Direction.Right;
        } else if (Input.GetKeyDown(KeyCode.UpArrow)) {
            newDirect = Direction.Up;
        } else if (Input.GetKeyDown(KeyCode.DownArrow)) {
            newDirect = Direction.Down;
        } else if (Input.GetKeyUp(KeyCode.LeftArrow) ||
            Input.GetKeyUp(KeyCode.RightArrow) ||
            Input.GetKeyUp(KeyCode.UpArrow) ||
            Input.GetKeyUp(KeyCode.DownArrow)) {
            newDirect = Direction.None;
       }
    }

    void updateCamera() {
        camera.transform.position = character.transform.position + cameraOffset;
    }
}
