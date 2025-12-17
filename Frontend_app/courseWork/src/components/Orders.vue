<template>
  <main class="orders-page">
    <div :hidden="!makingOrder">
      <div class="background">
        <button @click="makingOrder = !makingOrder">Закрыть окно</button>
        <MakeOrder />
      </div>
    </div>

    <div class="info">
      <div class="buttons">
        <button @click="makingOrder = !makingOrder">Разместить заказ</button>
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
        <button @click="i--" :disabled="i === 0"><span class="material-icons">arrow_left</span></button>
        <button @click="i++" :disabled="16 * (i + 1) > store.state.orders.length"><span class="material-icons">arrow_right</span></button>
      </div>
    </div>
  </main>
</template>

<script setup>
import Order from "./Order.vue";
import {useStore} from "vuex";
import {ref} from "vue";
import MakeOrder from "./MakeOrder.vue";

const store = useStore();

const i = ref(0);
const makingOrder = ref(true);

makingOrder.value = !makingOrder.value;
</script>

<style lang="scss" scoped>
.background {
  position: fixed;
  top: 0;
  left: 0px;
  padding: 3rem;
  margin: 0;
  right: 0;
  z-index: 2;
  width: 100%;
  height: 100%;
  background: rgba(0, 0, 0, 0.8);

  display: flex;
  flex-direction: column;

  button {
    color: var(--light);
    background-color: var(--dark-alt);

    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    padding-left: 2rem;
    padding-right: 2rem;
    margin: 3rem;
  }
}

.material-icons {
  font-size: 2rem;
  color: var(--light);
  margin: 0;
  padding: 0;
  text-align: center;
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
