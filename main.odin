// this file was created june 16, 2025

package main

import "core:fmt"
import "core:strings"
import "vendor:raylib"

Grid :: struct {
	x, y, w, h, ts: int,
}

drawGrid :: proc(g: Grid) {
	drawGridHelper :: proc(gridX, gridY, gridWidth, gridHeight, tileSize: int) {
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

getClosestBox :: proc(g: Grid, x, y: int) -> [2]int {
	boxNumX := (x - g.x) / g.ts
	boxNumY := (y - g.y) / g.ts
	return [?]int{boxNumX, boxNumY}
}

drawClosestBox :: proc(g: Grid, x, y: int, c: raylib.Color, filled: bool) {
	boxNum := getClosestBox(g, x, y)
	if !filled {
		raylib.DrawRectangleLines(
			i32(boxNum[0] * g.ts + g.x),
			i32(boxNum[1] * g.ts + g.y),
			i32(g.ts),
			i32(g.ts),
			c,
		)} else {
		raylib.DrawRectangle(
			i32(boxNum[0] * g.ts + g.x),
			i32(boxNum[1] * g.ts + g.y),
			i32(g.ts),
			i32(g.ts),
			c,
		)
	}
}

writeColorGridToFile :: proc(fileName: string, m: map[[2]int]int) {
	s := ""
	for pos, colIdx in m {
		line := [?]string{s, string(pos[0]), string(pos[1]), string(colIdx), "\n"}
		strings.concatenate(line[:])
	}
	raylib.SaveFileText(fileName, s)
}


main :: proc() {

	controlShiftPressed := false

	colorHexes := [?][3]int {
		[3]int{335, 49, 49},
		[3]int{358, 54, 92},
		[3]int{23, 53, 98},
		[3]int{48, 17, 100},
	}
	colors: [4]raylib.Color
	for i in 0 ..< 4 {
		colors[i] = raylib.ColorFromHSV(
			f32(colorHexes[i][0]),
			f32(colorHexes[i][1]) / 100.,
			f32(colorHexes[i][2]) / 100.,
		)
	}
	currColor := 0

	screenWidth :: 32 * 16 * 2
	screenHeight :: 32 * 9 * 2

	myGrid := Grid{0, 0, screenWidth, screenHeight, 32}

	colorGrid := make(map[[2]int]int)

	raylib.InitWindow(screenWidth, screenHeight, "my raylib window")
	raylib.SetTargetFPS(60)

	if !raylib.DirectoryExists("course_maps") {
		raylib.MakeDirectory("course_maps")
	}

	for !raylib.WindowShouldClose() {
		switch {
		case raylib.IsKeyDown(raylib.KeyboardKey.ONE):
			currColor = 0
		case raylib.IsKeyDown(raylib.KeyboardKey.TWO):
			currColor = 1
		case raylib.IsKeyDown(raylib.KeyboardKey.THREE):
			currColor = 2
		case raylib.IsKeyDown(raylib.KeyboardKey.FOUR):
			currColor = 3
		}

		if raylib.IsMouseButtonDown(raylib.MouseButton.LEFT) {
			colorGrid[getClosestBox(myGrid, int(raylib.GetMouseX()), int(raylib.GetMouseY()))] =
				currColor
		}

		if raylib.IsKeyDown(raylib.KeyboardKey.LEFT_CONTROL) &&
		   raylib.IsKeyPressed(raylib.KeyboardKey.LEFT_SHIFT) {
			controlShiftPressed = true
		}
		if !raylib.IsKeyDown(raylib.KeyboardKey.LEFT_CONTROL) ||
		   raylib.IsKeyDown(raylib.KeyboardKey.LEFT_SHIFT) {
			controlShiftPressed = false
		}
		if controlShiftPressed && raylib.IsKeyPressed(raylib.KeyboardKey.S) {
			writeColorGridToFile("course_maps/course_1.txt", colorGrid)
		}


		raylib.BeginDrawing()
		raylib.ClearBackground(raylib.RAYWHITE)
		drawGrid(myGrid)
		for pos, &colorIndex in colorGrid {
			drawClosestBox(
				myGrid,
				pos[0] * myGrid.ts + myGrid.x,
				pos[1] * myGrid.ts + myGrid.y,
				colors[colorIndex],
				true,
			)
		}
		drawClosestBox(
			myGrid,
			int(raylib.GetMouseX()),
			int(raylib.GetMouseY()),
			raylib.ORANGE,
			false,
		)
		raylib.EndDrawing()
	}

	raylib.CloseWindow()

}
