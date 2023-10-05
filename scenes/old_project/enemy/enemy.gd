extends RigidBody2D

@onready var animated  = $AnimatedSprite2D

func ready():
    var mob_types = animated.sprite_frames.get_animation_names()
    print(mob_types)
    animated.play(mob_types[randi() % mob_types.size()])

func _on_visible_on_screen_notifier_2d_screen_exited():
    queue_free()
