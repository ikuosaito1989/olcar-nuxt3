<script setup lang="ts">
const props = defineProps({
  label: {
    type: String,
    required: true,
  },
  isNewLine: {
    type: Boolean,
    default: false,
  },
})
</script>

<template>
  <div
    class="tw-my-2 tw-flex tw-flex-wrap tw-items-center"
    :class="{ 'tw-flex-col tw-items-baseline': isNewLine }"
  >
    <div>
      <v-chip size="default" class="tw-mr-1 tw-w-20 tw-justify-center tw-font-bold">
        {{ props.label }}
      </v-chip>
    </div>
    <div :class="{ 'tw-my-2': isNewLine }"><slot></slot></div>
  </div>
</template>
