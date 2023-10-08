package com.rans_innovations.clean_architecture_notebook


import android.widget.Toast
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private lateinit var channel: MethodChannel

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel =
            MethodChannel(
                flutterEngine.dartExecutor.binaryMessenger,
                "rans_innovations/notebook"
            )

        channel.setMethodCallHandler { call, _ ->
            if (call.method == "show_toast") {
                val message = call.arguments as String
                Toast.makeText(this, message, Toast.LENGTH_SHORT).show()
            }

        }

    }
}
