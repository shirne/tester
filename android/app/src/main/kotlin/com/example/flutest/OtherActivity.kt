package com.example.flutest

import android.app.Activity
import android.os.Bundle
import androidx.annotation.Nullable

class OtherActivity: Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.other_layout)
    }
}
