<template>
  <main class="carousel-component">
    <div class="info">
      <div class="text" style="padding: 1rem">Работы наших мастеров</div>
      <div class="carousel">
        <div class="center" v-for="order in store.state.orders.slice(0, 4)" :key="order.id">
          <Order :image="order.image" :name="order.name" :tags="order.types" :buttonsHiden="true" />
        </div>
      </div>
    </div>
  </main>
</template>

<script setup>
import {useStore} from "vuex";
import Order from "./Order.vue";

const store = useStore();
</script>

<style lang="scss" scoped>
.carousel {
  display: flex;
  flex-direction: row;
  text-align: center;
  justify-content: center;

  :deep(.text) {
    font-size: 1rem;
  }
}
</style>
