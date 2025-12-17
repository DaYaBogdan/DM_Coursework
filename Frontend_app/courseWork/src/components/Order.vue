<template>
  <main class="order-component">
    <div class="centered-content">
      <img :src="imageUrl" :alt="name" v-if="imageUrl" />
      <div class="text" id="name">{{ name }}</div>
      <div v-if="status">
        <div
          class="text"
          id="status"
          :class="{
            onServerHolding: status === 'В обработке',
            waitingForMaster: status === 'Размещён',
            workedOn: status === 'Принят мастером',
            complete: status === 'Завершен',
            declined: status === 'Отклонён',
          }"
        >
          {{ status }}
        </div>
      </div>
      <div class="text" id="tags">{{ tags.join(", ") }}</div>
      <div class="flexed-row">
        <button class="discard" @click="discardOrder()" :hidden="props.buttonsHiden" :disabled="disableDiscard()">Отменить</button>
        <button v-if="status != 'Принят мастером'" class="accept" @click="acceptOrder()" :hidden="props.buttonsHiden" :disabled="disableAccept()">
          Принять
        </button>
        <button v-else class="finish" @click="completeOrder()" :hidden="props.buttonsHiden" :disabled="disableComplete()">Сдать</button>
      </div>
    </div>
  </main>
</template>

<script setup>
import router from "@/router";
import {defineProps, ref, onMounted} from "vue";
import {useStore} from "vuex";

const store = useStore();

const props = defineProps({
  image: String,
  name: String,
  status: String,
  tags: Array,
  posted: String,
  master: String,
  buttonsHiden: Boolean,
});

const imageUrl = ref(null);

const disableDiscard = () => {
  if (props.status === "Отклонён") {
    return true;
  }
  if (store.state.account["login"] === props.posted) {
    return false;
  }
  if (store.state.account["role"] === "Администратор") {
    return false;
  }
  return true;
};

const disableAccept = () => {
  if (store.state.account["role"] === "Мастер") {
    if (props.status === "Размещён") {
      return false;
    }
  }
  return true;
};

const disableComplete = () => {
  return store.state.account.login !== props.master;
};

async function discardOrder() {
  const response = await fetch("http://localhost:8000/api/orders/discard_order", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: props.name,
      customer: props.posted,
      tags: props.tags,
    }),
  });

  if (!response.ok) {
    console.error("Ошибка отмены заказа");
    return;
  }

  await store.dispatch("setOrders");
  await store.dispatch("updateMoney");
}

async function acceptOrder() {
  const response = await fetch("http://localhost:8000/api/orders/accept_order", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: props.name,
      customer: props.posted,
      tags: props.tags,
      master: store.state.account["login"],
    }),
  });

  if (!response.ok) {
    console.error("Ошибка принятия заказа");
    return;
  }

  await store.dispatch("setOrders");
}

async function completeOrder() {
  const response = await fetch("http://localhost:8000/api/orders/complete_order", {
    method: "POST",
    headers: {
      "Content-Type": "application/json",
    },
    body: JSON.stringify({
      name: props.name,
      customer: props.posted,
      tags: props.tags,
    }),
  });

  if (!response.ok) {
    console.error("Ошибка завершения заказа");
    return;
  }

  await store.dispatch("setOrders");
  await store.dispatch("updateMoney");
}

onMounted(async () => {
  if (props.image) {
    imageUrl.value = `http://localhost:8000/api/get_image/${props.image}`;
  }
});
</script>

<style lang="scss" scoped>
button {
  color: var(--light);

  font-size: 1rem;
  border-radius: 0.5rem;
  width: 10rem;
  height: 3rem;
  padding-left: 2rem;
  padding-right: 2rem;
  margin: 3rem;

  &:disabled {
    background-color: var(--dark);
    color: var(--dark-alt);
  }
}

.discard {
  background-color: rgb(125, 0, 0);
}

.accept {
  background-color: green;
}

.finish {
  background-color: rgb(200, 130, 0);
}

.flexed-row {
  display: flex;
  flex-direction: row;
  justify-content: center;
}

img {
  width: 10rem;
  height: 14rem;
  margin: 0rem;
  border-radius: 1rem;
}

.centered-content {
  align-content: center;
  justify-content: center;
  text-align: center;
}

.bottom {
  justify-self: flex-end;
  margin-bottom: 2rem;
}

.text {
  font-size: 1.2rem;
  padding: 0.5rem;
}

@mixin setStatus($color) {
  background-color: $color;
  border-radius: 1rem;
}

.onServerHolding {
  @include setStatus(rgb(0, 200, 200));
}

.waitingForMaster {
  @include setStatus(rgb(56, 56, 56));
}

.workedOn {
  @include setStatus(rgb(200, 130, 0));
}

.complete {
  @include setStatus(green);
}

.declined {
  @include setStatus(rgb(200, 0, 0));
}
</style>
