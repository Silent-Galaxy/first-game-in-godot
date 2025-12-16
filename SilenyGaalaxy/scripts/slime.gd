extends Node2D

# سرعت حرکت دشمن (پیکسل بر ثانیه)
const SPEED = 60

# جهت حرکت: 1 یعنی راست، -1 یعنی چپ
var direction = 1

# دسترسی به نودهای RayCast (چشم‌های دشمن) و اسپرایت
@onready var ray_cast_right = $RayCastRight
@onready var ray_cast_left = $RayCastLeft
@onready var animated_sprite = $AnimatedSprite2D

# این تابع در هر فریم اجرا می‌شود (برای حرکت غیر فیزیکی)
func _process(delta):
	# 1. بررسی برخورد از سمت راست
	# اگر اشعه سمت راست به دیوار برخورد کرد:
	if ray_cast_right.is_colliding():
		direction = -1               # تغییر جهت به چپ
		animated_sprite.flip_h = true # چرخاندن تصویر به سمت چپ
	
	# 2. بررسی برخورد از سمت چپ
	# اگر اشعه سمت چپ به دیوار برخورد کرد:
	if ray_cast_left.is_colliding():
		direction = 1                 # تغییر جهت به راست
		animated_sprite.flip_h = false # چرخاندن تصویر به سمت راست (حالت عادی)
	
	# 3. اعمال حرکت
	# فرمول: مکان فعلی + (جهت * سرعت * زمان سپری شده)
	# ضرب در delta باعث می‌شود سرعت در کامپیوترهای قوی و ضعیف یکسان باشد
	position.x += direction * SPEED * delta
