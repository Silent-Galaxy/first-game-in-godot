extends CharacterBody2D

# --- تنظیمات قابل تغییر در اینسپکتور ---
# با استفاده از @export می‌توانیم این اعداد را از بیرون کد تغییر دهیم
@export var speed = 130.0          # سرعت حرکت افقی
@export var jump_velocity = -300.0 # قدرت پرش (منفی یعنی به سمت بالا)

# دریافت مقدار جاذبه از تنظیمات پروژه برای هماهنگی با فیزیک دنیا
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

# دسترسی به نود انیمیشن اسپرایت
@onready var animated_sprite = $AnimatedSprite2D

func _physics_process(delta):
	# 1. اعمال جاذبه (Gravity)
	# اگر کاراکتر روی زمین نباشد، باید سقوط کند
	# delta باعث می‌شود سرعت بازی در سیستم‌های قوی و ضعیف یکسان باشد
	if not is_on_floor():
		velocity.y += gravity * delta

	# 2. مدیریت پرش (Jump)
	# اگر دکمه پرش زده شد و کاراکتر روی زمین بود
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	# 3. دریافت ورودی حرکت (Input)
	# این تابع جهت را تشخیص می‌دهد: -1 (چپ)، 1 (راست) یا 0 (ایستاده)
	var direction = Input.get_axis("move_left", "move_right")
	
	# 4. مدیریت حرکت و توقف (Movement)
	if direction:
		# اگر دکمه‌ای فشرده شده، سرعت را تنظیم کن
		velocity.x = direction * speed
	else:
		# اگر دکمه رها شد، سرعت را نرم به صفر برسان (اصطکاک)
		velocity.x = move_toward(velocity.x, 0, speed)

	# 5. مدیریت انیمیشن‌ها (Animations)
	update_animation(direction)

	# 6. اجرای فیزیک (Physics Apply)
	# این تابع بر اساس velocity تنظیم شده، کاراکتر را حرکت می‌دهد و برخوردها را چک می‌کند
	move_and_slide()

# تابعی جداگانه برای مدیریت انیمیشن‌ها جهت تمیزتر شدن کد
func update_animation(direction):
	# چرخش کاراکتر بر اساس جهت حرکت
	if direction > 0:
		animated_sprite.flip_h = false # نگاه به راست
	elif direction < 0:
		animated_sprite.flip_h = true  # نگاه به چپ
	
	# انتخاب انیمیشن بر اساس وضعیت (روی زمین یا هوا)
	if is_on_floor():
		if direction == 0:
			animated_sprite.play("idle") # ایستاده
		else:
			animated_sprite.play("run")  # در حال دویدن
	else:
		animated_sprite.play("jump")     # در حال پرش
