package com.example.template.core.common.network

import javax.inject.Qualifier
import kotlin.annotation.AnnotationRetention.RUNTIME

@Qualifier
@Retention(RUNTIME)
annotation class Dispatcher(val templateDispatcher: TemplateDispatchers)

enum class TemplateDispatchers {
    Default,
    IO,
}
