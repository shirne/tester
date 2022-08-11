package com.example.flutest

import android.app.Activity
import android.os.Bundle
import android.widget.TextView
import androidx.annotation.Nullable

class OtherActivity: Activity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.other_layout)
        val title:String? = getIntent().getStringExtra("title")
        System.out.println(title)
        if(title !=null){
            findViewById<TextView>(R.id.am_text).setText(title)
        }
    }
}
