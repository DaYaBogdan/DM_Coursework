<template>
  <main class="MakeOrder-page">
    <div class="background">
      <RouterLink :to="{name: 'Ваши заказы'}">Закрыть окно</RouterLink>
      <div class="info">
        <div class="flexed-all">
          <div class="flexed">
            <div class="text">Введите название для заказа:</div>
            <input placeholder="Название" type="text" v-model="formData.name" />
          </div>
          <div class="flexed">
            <div class="text">Выберите теги:</div>
            <v-select
              class="select"
              label="Теги"
              :items="store.state.types"
              item-title="name"
              item-value="name"
              v-model="formData.tags"
              multiple
              chips
            />
          </div>
          <div class="flexed">
            <button @click="sendOrder()">Отправить заказ</button>
          </div>
        </div>
      </div>
    </div>
  </main>
</template>

<script setup>
import {reactive, onMounted} from "vue";
import {useStore} from "vuex";
import router from "@/router";

const store = useStore();
const formData = reactive({
  name: "",
  tags: [],
});

async function sendOrder() {
  const response = await fetch("http://localhost:8000/api/orders/make_order", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: formData.name,
      customer: store.state.account["login"],
      tags: formData.tags,
    }),
  });

  if (!response.ok) {
    console.error("Ошибка принятия заказа");
    return;
  }

  await store.dispatch("setOrders");
  await store.dispatch("updateMoney");
  router.push("/Orders");
}

onMounted(() => {
  store.dispatch("fetchTypes");
});
</script>

<style lang="scss" scoped>
a {
  color: var(--light);
  background-color: var(--dark);

  font-size: 2rem;
  border-radius: 0.5rem;
  width: fit-content;
  height: 3rem;
  padding: 0 2rem;
  margin: 3rem;

  text-decoration: none;
  border: none;
  outline: none;
  display: inline-flex;
  align-items: center;

  &.router-link-active,
  &.router-link-exact-active {
    color: var(--light);
    background-color: var(--dark);
  }
}

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
    background-color: var(--dark);

    font-size: 2rem;
    border-radius: 0.5rem;
    width: fit-content;
    height: 3rem;
    padding-left: 2rem;
    padding-right: 2rem;
    margin: 3rem;
  }
}

.flexed {
  display: flex;
  flex-direction: row;
  justify-content: center;
  align-items: center;
}

.flexed-all {
  display: flex;
  flex-direction: column;
  justify-content: space-between;
  gap: 2rem;
}

.text {
  padding: 2rem;
  padding-right: 1rem;
}

input {
  width: 20rem;
  height: 3rem;
  border-radius: 0.5rem;
  padding: 1rem;
  font-family: var(--font);
  background-color: var(--light);

  ::placeholder {
    color: var(--dark);
  }

  &::placeholder {
    text-align: center;
  }

  font-size: 1rem;
}

.select {
  max-width: 40rem;
  border-radius: 1rem;
  background-color: var(--light);
  color: var(--dark-alt);
  justify-content: space-around;

  :deep(.v-chip) {
    font-size: 1rem;
  }
}
</style>
