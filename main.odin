// this file was created june 16, 2025

package main

import "core:fmt"
import "vendor:raylib"

Grid :: struct {
	x, y, w, h, ts: int,
}

drawGrid :: proc(g: Grid) {
	drawGridHelper :: proc(gridX, gridY, gridWidth, gridHeight, tileSize: int) {
        fmt.println("inside helper")
		for i in 1 ..= (gridWidth / tileSize) {
			x := tileSize * i + gridX
			raylib.DrawLine(i32(x), i32(gridY), i32(x), i32(gridY + gridHeight), raylib.BLACK)
		}
		for j in 1 ..= (gridHeight / tileSize) {
			y := tileSize * j + gridY
			raylib.DrawLine(i32(gridX), i32(y), i32(gridX + gridWidth), i32(y), raylib.BLACK)
		}
	}

	drawGridHelper(g.x, g.y, g.w, g.h, g.ts)
}

drawClosestBox :: proc(g: Grid, x, y : int) {
    boxNumX := (x - g.x) / g.ts
    boxNumY := (y - g.y) / g.ts
    raylib.DrawRectangleLines(i32(boxNumX * g.ts + g.x),
    i32(boxNumY * g.ts + g.y), i32(g.ts), i32(g.ts), raylib.ORANGE)
}


main :: proc() {

	screenWidth :: 32 * 16 * 2
	screenHeight :: 32 * 9 * 2

	myGrid := Grid{0, 0, screenWidth, screenHeight, 32}

	raylib.InitWindow(screenWidth, screenHeight, "my raylib window")
	raylib.SetTargetFPS(60)

	for !raylib.WindowShouldClose() {
		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)
		drawGrid(myGrid)
        drawClosestBox(myGrid, int(raylib.GetMouseX()), int(raylib.GetMouseY()))
		raylib.EndDrawing()
	}

	raylib.CloseWindow()

}
