import { h, reactive } from "vue"

const passthrough = (tag = "div") => ({
  inheritAttrs: false,
  setup(_, { slots, attrs }) {
    return () => h(tag, attrs, slots.default ? slots.default() : [])
  },
})

const withActivator = (tag = "div") => ({
  props: ["modelValue"],
  emits: ["update:modelValue"],
  inheritAttrs: false,
  setup(props, { slots, attrs, emit }) {
    const toggle = () => emit("update:modelValue", !props.modelValue)
    return () =>
      h(tag, attrs, [
        slots.activator
          ? slots.activator({
              on: { click: toggle },
              attrs: {},
              props: { onClick: toggle },
            })
          : null,
        props.modelValue && slots.default ? slots.default() : null,
      ])
  },
})

const VHover = {
  setup(_, { slots }) {
    return () => (slots.default ? slots.default({ hover: false }) : null)
  },
}

const VTextField = {
  props: ["modelValue"],
  emits: ["update:modelValue"],
  inheritAttrs: false,
  setup(props, { emit, attrs }) {
    return () =>
      h("input", {
        ...attrs,
        class: [attrs.class, "legacy-input"].filter(Boolean).join(" "),
        value: props.modelValue ?? "",
        onInput: (e) => emit("update:modelValue", e.target.value),
      })
  },
}

const VTextarea = {
  props: ["modelValue"],
  emits: ["update:modelValue"],
  inheritAttrs: false,
  setup(props, { emit, attrs }) {
    return () =>
      h(
        "textarea",
        {
          ...attrs,
          class: [attrs.class, "legacy-textarea"].filter(Boolean).join(" "),
          value: props.modelValue ?? "",
          onInput: (e) => emit("update:modelValue", e.target.value),
        },
        [],
      )
  },
}

const VBtn = {
  inheritAttrs: false,
  emits: ["click"],
  setup(_, { slots, attrs, emit }) {
    return () =>
      h(
        "button",
        {
          ...attrs,
          type: attrs.type || "button",
          onClick: (e) => emit("click", e),
        },
        slots.default ? slots.default() : [],
      )
  },
}

const VIcon = passthrough("span")

const VNavigationDrawer = {
  props: ["modelValue"],
  emits: ["update:modelValue"],
  inheritAttrs: false,
  setup(props, { slots, attrs }) {
    return () =>
      props.modelValue
        ? h("aside", { ...attrs, class: [attrs.class, "v-navigation-drawer"].filter(Boolean).join(" ") }, slots.default ? slots.default() : [])
        : null
  },
}

const VRow = {
  inheritAttrs: false,
  setup(_, { slots, attrs }) {
    return () => h("div", { ...attrs, class: [attrs.class, "v-row"].filter(Boolean).join(" ") }, slots.default ? slots.default() : [])
  },
}

const VCol = {
  inheritAttrs: false,
  setup(_, { slots, attrs }) {
    const span = Number(attrs.cols || 12)
    const width = `${(Math.max(1, Math.min(span, 12)) / 12) * 100}%`
    return () =>
      h(
        "div",
        {
          ...attrs,
          class: [attrs.class, "v-col"].filter(Boolean).join(" "),
          style: [attrs.style, `flex:0 0 ${width};max-width:${width};`].filter(Boolean).join(";"),
        },
        slots.default ? slots.default() : [],
      )
  },
}

const components = {
  "v-app": passthrough("div"),
  "v-main": passthrough("main"),
  "v-container": passthrough("div"),
  "v-app-bar": passthrough("header"),
  "v-navigation-drawer": VNavigationDrawer,
  "v-list": passthrough("ul"),
  "v-list-item-group": passthrough("div"),
  "v-list-item": passthrough("li"),
  "v-list-item-title": passthrough("div"),
  "v-list-item-content": passthrough("div"),
  "v-list-item-subtitle": passthrough("div"),
  "v-row": VRow,
  "v-col": VCol,
  "v-card": passthrough("section"),
  "v-card-actions": passthrough("div"),
  "v-dialog": withActivator("div"),
  "v-menu": withActivator("div"),
  "v-form": passthrough("form"),
  "v-simple-table": passthrough("table"),
  "v-expansion-panels": passthrough("div"),
  "v-expansion-panel": passthrough("div"),
  "v-expansion-panel-header": passthrough("button"),
  "v-expansion-panel-content": passthrough("div"),
  "v-spacer": passthrough("span"),
  "v-divider": passthrough("hr"),
  "v-checkbox": passthrough("label"),
  "v-select": passthrough("select"),
  "v-date-picker": passthrough("div"),
  "v-toolbar": passthrough("div"),
  "v-flex": passthrough("div"),
  "v-virtual-scroll": passthrough("div"),
  "v-expand-transition": passthrough("div"),
  "v-hover": VHover,
  "v-btn": VBtn,
  "v-icon": VIcon,
  "v-text-field": VTextField,
  "v-textarea": VTextarea,
}

export default {
  install(app) {
    const breakpoint = reactive({
      xs: false,
      sm: false,
      md: true,
      lg: false,
      xl: false,
    })

    const syncBreakpoint = () => {
      if (typeof window === "undefined") return
      const w = window.innerWidth
      breakpoint.xs = w < 600
      breakpoint.sm = w >= 600 && w < 960
      breakpoint.md = w >= 960 && w < 1264
      breakpoint.lg = w >= 1264 && w < 1904
      breakpoint.xl = w >= 1904
    }

    syncBreakpoint()
    if (typeof window !== "undefined") {
      window.addEventListener("resize", syncBreakpoint)
    }

    app.config.globalProperties.$vuetify = { breakpoint }

    Object.entries(components).forEach(([name, component]) => {
      app.component(name, component)
    })
  },
}
