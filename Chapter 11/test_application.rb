require 'fox16'

include Fox

myApp = FXApp.new

# FXMainWindow objects are windows;
# our single control will be inside this
# window.

mainWindow=FXMainWindow.new(myApp, "Test App")

# FXButton object's are clickable buttons.

my_button= FXButton.new(mainWindow, 'Click Me!')
my_button.connect(SEL_COMMAND) do
  my_button.text="I've been clicked!"
end

myApp.create

mainWindow.show( PLACEMENT_SCREEN )

myApp.run

