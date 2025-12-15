<template>
  <main class="report-component">
    <div class="display-flexed">
      <div class="text" id="reporter">From: {{ reporter }}</div>
      <div class="text" id="reported">To: {{ reported }}</div>
      <div class="text" id="description">Report: {{ descriprion }}</div>
    </div>
  </main>
</template>

<script setup>
const props = defineProps({
  descriprion: String,
  reporter: String,
  reported: String,
});
</script>
