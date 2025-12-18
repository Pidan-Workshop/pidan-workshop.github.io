components {
  id: "tilemap"
  component: "/game/levels/level7.tilemap"
}
components {
  id: "level"
  component: "/game/levels/level.script"
}
embedded_components {
  id: "ghost_factory"
  type: "factory"
  data: "prototype: \"/game/enemy/ghost.go\"\n"
}
