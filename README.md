# Shapes
Demonstration of drawing shapes and animating them, custom draggable button.

# Functionality
Three shapes are being drawn on start of the app and green circle view is shown in bottom right corner.

Shapes are: 
- Red circle on the top
- Blue triangle below circle
- Orange star below triangle.

Green circle view is interactive in a way that you can click on it and swipe it over the screen. 
When you stop dragging the button, it will pin to a closest available corner point. 

Available corner points:
- Top right (top left is considered as top right)
- Bottom left
- Bottom right

When blue circle button inside green view is tapped, blue button changes color to red and the green view will expand and shows you shapes drawn on main screen.

When red circle button inside green expanded view is tapped, it will change back button color to blue and hides shapes inside green view. 

When clicked on any of the 3 shapes in expanded green view, then the clicked shape will do some of 3 animations depending on current position of green button.  
- If green button is at top right corner, then selected shape will change it's size.
- If green button is at bottom left corner, then selected shape will change it's alpha.
- If green button is at bottom right corner, then selected shape will rotate.

