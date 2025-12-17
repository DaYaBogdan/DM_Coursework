<template>
  <main class="report-component">
    <div class="make-more-visible">
      <div class="display-flexed">
        <div class="text" id="reporter">От: {{ reporter }}, про: {{ reported }}</div>
        <div class="text" id="description">Жалоба: {{ description }}</div>
      </div>
    </div>
  </main>
</template>

<script setup>
const props = defineProps({
  description: String,
  reporter: String,
  reported: String,
});
</script>

<style lang="scss" scoped>
.make-more-visible {
  background-color: var(--dark);
  border-radius: 1rem;
  box-shadow: 0.5rem 0.5rem 0.5rem var(--primary-alt);
}

.display-flexed {
  flex-direction: column;
  justify-content: left;
  align-items: flex-start;
}

.text {
  font-size: 2rem;
  text-align: left;
}
</style>
>
