<template>
  <main class="orders-page">
    <div class="info">
      <div class="buttons">
        <button>
          <RouterLink :to="{name: 'Сделать заказ'}">Разместить заказ</RouterLink>
        </button>
      </div>
      <div class="orders-list">
        <Order
          v-for="order in store.state.orders.slice(16 * i, 16 * (i + 1))"
          :key="order.id"
          :image="order.image"
          :name="order.name"
          :status="order.order_status"
          :tags="order.types"
        />
      </div>
      <div class="buttons justify-center">
        <button @click="i--" :disabled="i === 0"><span class="material-icons">arrow_back_ios</span></button>
        <button @click="i++" :disabled="16 * i > store.state.orders"><span class="material-icons">arrow_forward_ios</span></button>
      </div>
    </div>
  </main>
</template>

<script setup>
import Order from "./Order.vue";
import {useStore} from "vuex";
import {ref} from "vue";

const store = useStore();

const i = ref(0);
</script>

<style lang="scss" scoped>
.material-icons {
  font-size: 2rem;
  color: var(--light);
}

a {
  text-decoration: none;
  &:link {
    color: var(--light);
  }
  &:visited {
    color: var(--primary);
  }
}

.buttons {
  display: flex;
  justify-content: space-between;
  flex-direction: row;
  padding: 2rem;

  button {
    color: var(--light);
    background-color: var(--dark);
    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    // margin: 1rem;
    padding-left: 1rem;
    padding-right: 1rem;

    .text {
      padding: 0;
      margin: 0;
    }
  }
}

.justify-center {
  justify-content: center;
  gap: 2rem;
}

.orders-list {
  display: grid;
  grid-template-columns: repeat(4, 4fr);
  justify-content: space-between;
}
span {
  font-size: 2rem;
}
</style>
