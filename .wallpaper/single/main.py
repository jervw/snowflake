from ImageGoNord import NordPaletteFile, GoNord

# E.g. Replace pixel by pixel
go_nord = GoNord()
image = go_nord.open_image("jinx.jpg")
go_nord.convert_image(image, save_path='jinx-nord.jpg')
