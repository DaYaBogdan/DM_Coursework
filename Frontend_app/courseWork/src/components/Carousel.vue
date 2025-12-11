<template>
  <main class="carousel-component">
    <div class="info">
      <div class="text" style="padding: 1rem">Работы наших мастеров</div>
      <div class="carousel">
        <div class="center" v-for="order in orders" :key="order.id">
          <Order :image="order.image" :name="order.name" :tags="order.types" />
        </div>
      </div>
    </div>
  </main>
</template>

<script setup>
import {ref, onMounted} from "vue";
import Order from "./Order.vue";

const orders = ref([]);

async function getOrders() {
  try {
    const response = await fetch("http://localhost:8000/api/orders/get_listing");
    if (!response.ok) throw new Error("Ошибка сети");

    const data = await response.json();
    orders.value = data.data.slice(0, 5) || [];
  } catch (error) {
    console.error("Ошибка:", error);
    orders.value = [];
  }
}

onMounted(() => {
  getOrders();
});
</script>

<style lang="scss" scoped>
.carousel {
  display: flex;
  flex-direction: row;
  text-align: center;
  justify-content: center;

  .text {
    padding: 1rem;
  }
}
</style>
