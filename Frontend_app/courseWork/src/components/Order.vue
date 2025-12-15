<template>
  <main class="order-component">
    <div class="display-flexed">
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
    </div>
  </main>
</template>

<script setup>
import {defineProps, ref, onMounted} from "vue";

const props = defineProps({
  image: String,
  name: String,
  status: String,
  tags: Array,
});

const imageUrl = ref(null);

onMounted(async () => {
  if (props.image) {
    setInterval(() => {
      console.log(props.image);
      console.log(props.status);
      imageUrl.value = `http://localhost:8000/api/get_image/${props.image}`;
    }, 3000);
  }
});
</script>

<style lang="scss" scoped>
img {
  width: 10rem;
  height: 14rem;
  margin: 0rem;
  border-radius: 1rem;
}

.display-flexed {
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
  @include setStatus(rgb(200, 200, 0));
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
