components {
  id: "menu"
  component: "/menu/menu.gui"
}
components {
  id: "controls"
  component: "/menu/controls.gui"
}
components {
  id: "credits"
  component: "/menu/credits.gui"
}
embedded_components {
  id: "sprite"
  type: "sprite"
  data: "default_animation: \"bg2\"\nmaterial: \"/builtins/materials/sprite.material\"\ntextures {\n  sampler: \"texture_sampler\"\n  texture: \"/main/main.atlas\"\n}\n"
  position {
    x: 36.5
    y: 80.5
  }
}
embedded_components {
  id: "sprite1"
  type: "sprite"
  data: "default_animation: \"bg2\"\nmaterial: \"/builtins/materials/sprite.material\"\ntextures {\n  sampler: \"texture_sampler\"\n  texture: \"/main/main.atlas\"\n}\n"
  position {
    x: 397.5
    y: 169.5
  }
  rotation {
    z: 1.0
    w: 6.123234E-17
  }
}
