extends Button

var _full_screen_content_callback := FullScreenContentCallback.new()
var on_user_earned_reward_listener := OnUserEarnedRewardListener.new()
var _rewarded_ad : RewardedAd

# Called when the node enters the scene tree for the first time.
func _ready():
	_full_screen_content_callback.on_ad_clicked = func() -> void:
		print("on_ad_clicked")
	_full_screen_content_callback.on_ad_dismissed_full_screen_content = func() -> void:
		print("on_ad_dismissed_full_screen_content")
	_full_screen_content_callback.on_ad_failed_to_show_full_screen_content = func(ad_error : AdError) -> void:
		print("on_ad_failed_to_show_full_screen_content")
	_full_screen_content_callback.on_ad_impression = func() -> void:
		print("on_ad_impression")
	_full_screen_content_callback.on_ad_showed_full_screen_content = func() -> void:
		print("on_ad_showed_full_screen_content")
	on_user_earned_reward_listener.on_user_earned_reward = func(rewarded_item : RewardedItem):
		print("on_user_earned_reward, rewarded_item: rewarded", rewarded_item.amount, rewarded_item.type)
	
	if _rewarded_ad:
		_rewarded_ad.destroy()
		_rewarded_ad = null

	var unit_id : String
	if OS.get_name() == "Android":
		unit_id = "ca-app-pub-3940256099942544/5224354917"
	elif OS.get_name() == "iOS":
		unit_id = "ca-app-pub-3940256099942544/1712485313"

	var rewarded_ad_load_callback := RewardedAdLoadCallback.new()
	rewarded_ad_load_callback.on_ad_failed_to_load = func(adError : LoadAdError) -> void:
		print(adError.message)

	rewarded_ad_load_callback.on_ad_loaded = func(rewarded_ad : RewardedAd) -> void:
		print("rewarded ad loaded" + str(rewarded_ad._uid))
		_rewarded_ad = rewarded_ad
		_rewarded_ad.full_screen_content_callback = _full_screen_content_callback

	RewardedAdLoader.new().load(unit_id, AdRequest.new(), rewarded_ad_load_callback)
 
	#Test id : ca-app-pub-3940256099942544/5224354917
	#MyId : "ca-app-pub-4095654602209013~4785337441"


func _on_pressed():
	if _rewarded_ad:
		_rewarded_ad.show(on_user_earned_reward_listener)
