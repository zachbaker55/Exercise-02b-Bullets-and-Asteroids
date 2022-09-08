# Exercise-02b-Bullets-and-Asteroids

Exercise for MSCH-C220

Fork the repository. When that process has completed, make sure that the top of the repository reads `[your username]/Exercise-02b-Bullets-and-Asteroids`. Edit the LICENSE and replace BL-MSCH-C220-F22 with your full name. Commit your changes.

Press the green "Code" button and select "Open in GitHub Desktop". Allow the browser to open (or install) GitHub Desktop. Once GitHub Desktop has loaded, you should see a window labeled "Clone a Repository" asking you for a Local Path on your computer where the project should be copied. Choose a location; make sure the Local Path ends with "Exercise-02b-Bullets-and-Asteroids" and then press the "Clone" button. GitHub Desktop will now download a copy of the repository to the location you indicated.

Open Godot. In the Project Manager, tap the "Import" button. Tap "Browse" and navigate to the repository folder. Select the project.godot file and tap "Open".

You will now see where we left off in Exercise-02a: a simple scene, containing a parent Node2D, a KinamaticBody2D (called Player) with corresponding Sprite nodes (for the ship and exhaust) and a Collision Polygon. Player has a script attached to it (Player.gd) which doesn't do too much for now; it makes sure the player wraps around the screen (the `wrapf` statements) and allows the player to accelerate and rotate.

This is what you will need to accomplish as part of this exercise:

To create the bullet: 
  - Create a new 2D scene. Rename "Node2D" to "Bullet"
  - Change the type of "Bullet" to KinematicBody2D
  - Select the Bullet node. In the Inspector panel, deselect both the Layer and Mask under PhysicsBody2D->Collision
  - As a child of Bullet, add a Sprite node, a Timer node, and an Area2D
  - As a child of Area2D, add a CollisionShape
  - Select the Sprite node. In the Inspector, update the Texture property to `res://Assets/Bullet.png` (drag in the image from the FileSystem panel)
    - In the Sprite menu in the toolbar, select `Create CollisionPolygon2D Sibling`
  - Select the Area2D/CollisionShape node. In the Inspector panel, set the Shape to `new CircleShape2D`. Edit the CircleShape2D and set the radius to 12.
  - Attach a script to Bullet. Save the script as `res://Player/Bullet.gd`
    - The bullet script will need to be responsible for moving the bullet. You will need to add `velocity`, `speed`, and `damage` variables. damage can be assigned to 1 for now, and speed can be assigned 500.0.
    - In the `_ready()` callback set `velocity = Vector2(0,-speed)`, and it should then be rotated by `rotation`
    - In _physics_process(_delta), instead of adding the velocity directly to the position, we will use a built-in method from KinematicBody2D: move_and_slide. The statement should be `velocity = move_and_slide(velocity, Vector2.UP)`
  - Save the script, and go back to the Scene panel. Select the Timer. In the Inspectory Panel, set One Shot and Autostart both to On. In the Node panel, create a new timeout() signal. Connect it to `res://Player/Bullet.gd`. The newly created `_on_Timer_timeout()` callback should cause the bullet to `queue_free()`
  - Back in the Scene panel, select the Area2D node. In the Node panel, add a body_entered signal and connect it to `res://Player/Bullet.gd`. The resulting `_on_Area2D_body_entered(body)` callback should also cause the bullet to `queue_free()`.
  - Save the bullet scene as `res://Player/Bullet.tscn`

To create the asteroid:
  - Create a new 2D scene. Change the root node to KinematicBody2D and rename it "Asteroid"
  - Add a Sprite. Update the Sprite's texture to contain `res://Assets/Asteroid.png`
  - Add a CollisionPolygon2D Sibling for the Sprite
  - Attach a script to the Asteroid node. Save it as `res://Asteroid/Asteroid.gd`
  - The asteroid script will need two variables: `velocity` and `initial_speed`. Set `initial_speed = 3.0`
  - Create a `_ready()` callback, and in `_ready()`, type the following: `velocity = Vector2(0,randf()*initial_speed).rotated(randf()*2*PI)`
  - Create `_physics_process()`. In `_physics_process`, update the position based on the velocity, and use wrapf to keep the position in the viewport.
  - Save the asteroid scene as `res://Asteroid/Asteroid.tscn`

Back in Game.tscn:
  - Create a Node2D as child of Game. Rename it "Asteroid_Container"
  - Create a Node2D as child of Game. Rename it "Effects"
  - Right-click on Asteroid_Container and select `Instance Child Scene`. Select `res://Asteroid/Asteroid.tscn`. In the Inspector, position it at 100,100
  - Repeat this process to place a second Asteroid in the scene. Position it at 800,500

In Player.gd:
  - Update speed = 5.0 and max_speed = 400.0
  - Create a new variable: `var nose = Vector2(0,-60)`
  - We also want to load the Bullet scene so it is available to use in this context: `onready var Bullet = load("res://Player/Bullet.tscn")`
  - Create a new function `get_input()`. This should return a Vector2 representing what is currently being pressed by the player:
  ```
func get_input():
	var to_return = Vector2.ZERO
	$Exhaust.hide()
	if Input.is_action_pressed("forward"):
		to_return += Vector2(0,-1)
		$Exhaust.show()
	if Input.is_action_pressed("left"):
		rotation_degrees -= rot_speed
	if Input.is_action_pressed("right"):
		rotation_degrees += rot_speed
	return to_return.rotated(rotation)
  ```
  - Update _physics_process to use `move_and_slide` instead of updating the position directly. When you are done, it should look something like this:
  ```
func _physics_process(_delta):
	velocity += get_input()*speed
	velocity = velocity.normalized() * clamp(velocity.length(), 0, max_speed)
	velocity = move_and_slide(velocity, Vector2.ZERO)
	position.x = wrapf(position.x, 0.0, 1024.0)
	position.y = wrapf(position.y, 0.0, 600.0)
  ```
  - Finally, we need to be able to shoot. Add the following to the bottom of `_physics_process`:
  ```
	if Input.is_action_just_pressed("shoot"):
		var Effects = get_node_or_null("/root/Game/Effects")
		if Effects != null:
			var bullet = Bullet.instance()
			bullet.rotation = rotation
			bullet.global_position = global_position + nose.rotated(rotation)
			Effects.add_child(bullet)
  ```

In Global.gd:
  - Add a `_ready()` callback. In `_ready()`, call `randomize()`


Test it and make sure this is working correctly. The asteroids should drift across the screen, and you should be able to navigate and shoot at them. The get_input function from Player.gd is probably a good snippet to add to your gists.

Quit Godot. In GitHub desktop, you should now see the updated files listed in the left panel. In the bottom of that panel, type a Summary message (something like "Completes the mouse and keyboard exercise") and press the "Commit to master" button. On the right side of the top, black panel, you should see a button labeled "Push origin". Press that now.

If you return to and refresh your GitHub repository page, you should now see your updated files with the time when they were changed.

Now edit the README.md file. When you have finished editing, commit your changes, and then turn in the URL of the main repository page (`https://github.com/[username]/Exercise-Bullets-and-Asteroids`) on Canvas.

The final state of the file should be as follows (replacing my information with yours):
```
# Exercise-02b-Bullets-and-Asteroids

Exercise for MSCH-C220

A user-controlled ship for a space-shooter game. Recently added the ability to shoot at asteroids. Created in Godot.

## Implementation

Created using [Godot 3.5](https://godotengine.org/download)

Assets are provided by [Kenney.nl](https://kenney.nl/assets/space-shooter-extension), provided under a [CC0 1.0 Public Domain License](https://creativecommons.org/publicdomain/zero/1.0/).

## References
None

## Future Development
None

## Created by
Jason Francis
```
