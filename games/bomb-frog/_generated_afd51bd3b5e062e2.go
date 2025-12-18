components {
  id: "script"
  component: "/main/handler.script"
}
embedded_components {
  id: "game"
  type: "collectionproxy"
  data: "collection: \"/game/core/game.collection\"\n"
}
embedded_components {
  id: "menu"
  type: "collectionproxy"
  data: "collection: \"/menu/menu.collection\"\n"
}
