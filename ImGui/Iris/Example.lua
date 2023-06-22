local Iris = loadstring(game:HttpGet("https://raw.githubusercontent.com/x0581/Iris-Exploit-Bundle/main/bundle.lua"))().Init(game.CoreGui)
Iris:Connect(Iris.ShowDemoWindow)
Iris:Connect(function()
   Iris.Window({"My First Window!"}) do
       Iris.Text({"Hello, World"})
       if Iris.Button({"Save"}).clicked then
           print("Clicked!")
       end
       Iris.InputNum({"Input"})
       Iris.End()
   end
end)
