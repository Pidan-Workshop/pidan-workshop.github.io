components {
  id: "camera"
  component: "/game/core/game.camera"
}
components {
  id: "game"
  component: "/game/gui/game.gui"
}
components {
  id: "script"
  component: "/game/core/camera.script"
}
components {
  id: "shutter"
  component: "/game/gui/shutter.gui"
}
components {
  id: "gameover"
  component: "/game/gui/gameover.gui"
}
components {
  id: "clear"
  component: "/game/gui/clear.gui"
}
components {
  id: "getready"
  component: "/game/gui/getready.gui"
}
components {
  id: "complete"
  component: "/game/gui/complete.gui"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"bg\"\nmaterial: \"/builtins/materials/sprite.material\"\ntextures {\n  sampler: \"texture_sampler\"\n  texture: \"/main/main.atlas\"\n}\n"
  position {
    x: 56.5
    y: 86.5
  }
}
embedded_components {
  id: "sprite1"
  type: "sprite"
  data: "default_animation: \"bg\"\nmaterial: \"/builtins/materials/sprite.material\"\ntextures {\n  sampler: \"texture_sampler\"\n  texture: \"/main/main.atlas\"\n}\n"
  position {
    x: 397.5
    y: 169.5
  }
  rotation {
    z: 1.0
    w: 6.123234E-17
  }
}
