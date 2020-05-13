package org.godotengine.godot;

import android.app.Activity;
import android.os.Handler;
import android.content.Intent;
import android.content.Context;
import android.hardware.camera2.CameraManager;
import android.hardware.camera2.CameraManager.TorchCallback;
import com.godot.game.R;
import javax.microedition.khronos.opengles.GL10;

public class Flashlight extends Godot.SingletonBase {

    protected Activity appActivity;
    protected Context appContext;
    private Godot activity = null;
    private int instanceId = 0;
    private static boolean flashlightOn = false;
    private TorchCallback torchCallback = this.createTorchCallback();

    private TorchCallback createTorchCallback() {
        return new TorchCallback() {
            @Override
            public void onTorchModeUnavailable(String cameraId) {
                super.onTorchModeUnavailable(cameraId);
            }

            @Override
            public void onTorchModeChanged(String cameraId, boolean enabled) {
                super.onTorchModeChanged(cameraId, enabled);
                Flashlight.flashlightOn = enabled;
            }
        };
    }

    public void getInstanceId(int pInstanceId) {
        // You will need to call this method from Godot and pass in the get_instance_id().
        instanceId = pInstanceId;
    }

    static public Godot.SingletonBase initialize(Activity p_activity) {
        return new Flashlight(p_activity);
    }

    public Flashlight(Activity p_activity) {
        // Register class name and functions to bind.
        registerClass("Flashlight", new String[]
            {
                "getInstanceId",
                "isFlashlightOn"
            });
        this.appActivity = p_activity;
        this.appContext = appActivity.getApplicationContext();
        // You might want to try initializing your singleton here, but android
        // threads are weird and this runs in another thread, so to interact with Godot you usually have to do.
        this.activity = (Godot)p_activity;
        this.activity.runOnUiThread(new Runnable() {
                public void run() {
                    // Useful way to get config info from "project.godot".
                    String key = GodotLib.getGlobal("plugin/api_key");
                    // SDK.initializeHere();
                }
        });
        this.registerFlashlightState(this.appContext);
    }

    public void registerFlashlightState (Context context) {
        CameraManager cameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
	    cameraManager.registerTorchCallback(this.torchCallback, new Handler(context.getMainLooper()));
    }

    public void unregisterFlashlightState(Context context) {
        CameraManager cameraManager = (CameraManager) context.getSystemService(Context.CAMERA_SERVICE);
        cameraManager.unregisterTorchCallback(this.torchCallback);
    }

    public boolean isFlashlightOn() {
	    return Flashlight.flashlightOn;
    }

    // Forwarded callbacks you can reimplement, as SDKs often need them.

    protected void onMainActivityResult(int requestCode, int resultCode, Intent data) {}
    protected void onMainRequestPermissionsResult(int requestCode, String[] permissions, int[] grantResults) {}

    protected void onMainPause() {
    }
    protected void onMainResume() {}
    protected void onMainDestroy() {}

    protected void onGLDrawFrame(GL10 gl) {}
    protected void onGLSurfaceChanged(GL10 gl, int width, int height) {} // Singletons will always miss first 'onGLSurfaceChanged' call.

} 
