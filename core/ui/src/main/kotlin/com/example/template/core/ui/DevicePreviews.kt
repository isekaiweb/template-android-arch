package com.example.template.core.ui

import androidx.compose.ui.tooling.preview.Preview

/**
 * Multipreview annotation that represents various device sizes. Add this annotation to a composable
 * to render various devices.
 */
@Preview(
    name = "phone", device = "spec:width=360dp,height=640dp,dpi=480", showSystemUi = false,
    showBackground = true,
    backgroundColor = 0xFFFBF8FF,
)
@Preview(
    name = "landscape", device = "spec:width=640dp,height=360dp,dpi=480",
    showBackground = true,
    backgroundColor = 0xFFFBF8FF,
)
@Preview(
    name = "foldable", device = "spec:width=673dp,height=841dp,dpi=480", showSystemUi = false,
    showBackground = true,
    backgroundColor = 0xFFFBF8FF,
)
@Preview(
    name = "tablet", device = "spec:width=1280dp,height=800dp,dpi=480", showSystemUi = false,
    showBackground = true, backgroundColor = 0xFFFBF8FF,
)
annotation class DevicePreviews

@Preview(
    name = "phone", device = "spec:width=360dp,height=640dp,dpi=480", showSystemUi = false,
    showBackground = true,
    backgroundColor = 0xFFFBF8FF,
)
@Preview(
    name = "landscape", device = "spec:width=640dp,height=360dp,dpi=480",
    showBackground = true,
    backgroundColor = 0xFFFBF8FF,
)
annotation class CompactDevicePreviews


@Preview(
    name = "tablet", device = "spec:width=1280dp,height=800dp,dpi=480", showSystemUi = false,
    showBackground = true, backgroundColor = 0xFFFBF8FF,
)
annotation class WideDevicePreviews