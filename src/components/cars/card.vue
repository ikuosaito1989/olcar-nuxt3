<script setup lang="ts">
defineProps({
  detail: {
    type: Object as () => DetailBase,
    required: true,
  },
})
</script>

<template>
  <v-card>
    <v-card-subtitle>{{ detail.makerName }}</v-card-subtitle>
    <v-card-title>{{ detail.name }}</v-card-title>

    <v-img :src="detail.images[0]"></v-img>
    <Price :price="detail.price"></Price>

    <Item label="走行距離">
      <div>{{ format.toMileage(detail.mileage) }}</div>
    </Item>
    <Item label="車検">
      <div>
        {{
          format.toLocaleVehicleInspection(
            detail.vehicleInspection,
            detail.unknownVehicleInspection,
          )
        }}
      </div>
    </Item>
    <Item label="地域">
      <div>{{ format.toArea(detail.prefecture, detail.locality) }}</div>
    </Item>
    <Item label="説明">
      <!--eslint-disable-next-line vue/no-v-html-->
      <div v-html="detail.comment"></div>
    </Item>
  </v-card>
</template>