import * as Enums from "./enums.mjs"

export const panelReflectionSize = 50;
export const panelStyles = {
  [Enums.PanelContentTypes.GameSteam]: {
    width: 420,
    height: 196,
    getScale: position => [1, 0.74375, 0.59375, 0.49375, 0.421875, 0.36875][position] ?? 0.34,
    getXOffset: position => [0, -1, -65, -85, -91, -94, -95, -96, -96, -95, -94, -94][position] ?? -93,
    getYOffset: position => [0, 7, 11, 14, 16, 17][position] ?? 17,
  },
  [Enums.PanelContentTypes.GameGeneric]: {
    width: 420,
    height: 320,
    getScale: position => [1, 0.74375, 0.59375, 0.49375, 0.421875, 0.36875][position] ?? 0.34,
    getXOffset: position => [0, -1, -65, -85, -91, -94, -95, -96, -96, -95, -94, -94][position] ?? -93,
    getYOffset: position => [0, -7, -11, -14, -16, -17][position] ?? -17,
  },
  [Enums.PanelContentTypes.GameCover]: {
    width: 234,
    height: 320,
    getScale: position => [1, 0.859375, 0.753125, 0.66875, 0.6, 0.546875, 0.503125, 0.465625, 0.43125, 0.403125, 0.375, 0.35625, 0.334375, 0.31875][position],
    getXOffset: position => [0, -1, -27, -40, -47, -51, -53, -55, -55, -54, -52, -52][position] ?? -50,
    getYOffset: position => [0, -4, -7, -9, -11, -13, -14, -15, -15, -17, -17, -17][position] ?? -19,
  },
  [Enums.PanelContentTypes.Content]: {
    width: 458,
    height: 494,
    getScale: position => [1, 0.83, 0.71, 0.62, 0.48, 0.356, 0.232][position] ?? 0.108,
    getXOffset: position => [0, -2, -48][position] ?? -94,
    getYOffset: position => [0, 1, 2, 3][position] ?? 4,
  }
}

export function getIdealContentType(games) {
  const gamesArray = games.toVarArray();
  const getAssetsCount = assetType => gamesArray.reduce((acc, game) => acc + game.assets[assetType].length, 0);
  const assetsCountByContentType = [{
    contentType: Enums.PanelContentTypes.GameSteam,
    assetsCount: getAssetsCount("steam"),
    priority: 1
  }, {
    contentType: Enums.PanelContentTypes.GameCover,
    assetsCount: getAssetsCount("boxFront"),
    priority: 0
  }, {
    contentType: Enums.PanelContentTypes.GameCover,
    assetsCount: getAssetsCount("poster"),
    priority: 0
  }];

  const [{ contentType, assetsCount }] = assetsCountByContentType
    .sort((a, b) => (b.assetsCount + b.priority) - (a.assetsCount + a.priority));

  if (!assetsCount) return Enums.PanelContentTypes.GameGeneric;

  return contentType;
}
