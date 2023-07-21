package com.example.applovin_poc


import android.util.Log
import android.view.ViewGroup
import android.widget.FrameLayout
import androidx.annotation.NonNull
import com.applovin.mediation.MaxAd
import com.applovin.mediation.MaxAdFormat
import com.applovin.mediation.MaxAdViewAdListener
import com.applovin.mediation.MaxError
import com.applovin.mediation.ads.MaxAdView
import com.applovin.sdk.AppLovinSdkUtils
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity(), MaxAdViewAdListener{
    private lateinit var channel: MethodChannel
    private val bannerChannel="custom_height/bannerAd"
    private var adView: MaxAdView? = null

    override fun onAdLoaded(maxAd: MaxAd) {
    }

    override fun onAdLoadFailed(adUnitId: String?, error: MaxError?) {}

    override fun onAdDisplayFailed(ad: MaxAd?, error: MaxError?) {}

    override fun onAdClicked(maxAd: MaxAd) {}

    override fun onAdExpanded(maxAd: MaxAd) {}

    override fun onAdCollapsed(maxAd: MaxAd) {}

    override fun onAdDisplayed(maxAd: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

    override fun onAdHidden(maxAd: MaxAd) { /* DO NOT USE - THIS IS RESERVED FOR FULLSCREEN ADS ONLY AND WILL BE REMOVED IN A FUTURE SDK RELEASE */ }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        channel= MethodChannel(flutterEngine.dartExecutor.binaryMessenger,bannerChannel)

        channel.setMethodCallHandler { call, result ->
            if (call.method=="getBannerAd"){
                val arguments=call.arguments() as Map<String,Int>?
                val width=arguments?.get("width")
                if (width!=null) {
                    createBannerAd(width)
                    result.success("channel is working")
                }
            }
        }
    }

    fun createBannerAd (width: Int)
    {
        adView = MaxAdView("43fd08bd5b8eba93", this)
        adView?.setListener(this)

        // Stretch to the width of the screen for banners to be fully functional
//        val width = ViewGroup.LayoutParams.MATCH_PARENT

        // Get the adaptive banner height.
        val heightDp = MaxAdFormat.BANNER.getAdaptiveSize(width,this).height
        val heightPx = AppLovinSdkUtils.dpToPx(this, heightDp)

        adView?.layoutParams = FrameLayout.LayoutParams(width*3, heightPx,1)
        adView?.setExtraParameter("adaptive_banner", "true")
//        adView?.setLocalExtraParameter("adaptive_banner_width", 600)
//        adView?.adFormat?.getAdaptiveSize(600, context)?.height  // Set your ad height to this value

        // Set background or background color for banners to be fully functional
        adView?.setBackgroundColor(R.color.red)

        val rootView = findViewById<ViewGroup>(android.R.id.content)
        rootView.addView(adView)
        print("adview: ${adView}")

        // Load the ad
        adView?.loadAd()
    }
}
