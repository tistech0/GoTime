<template>
    <div>
        <div id="chart"></div>
    </div>
</template>
  
<script lang="ts">
import { defineComponent, ref, onMounted } from 'vue';
import ApexCharts from 'apexcharts';

export default defineComponent({
    props: {
        min: {
            type: Array,
            required: true,
        },
        max: {
            type: Array,
            required: true,
        },
        series: {
            type: Array,
            required: true,
        },
    },
    setup(props) {
        const chart = ref<ApexCharts | null>(null);

        const options = {
            series: props.series,
            chart: {
                type: 'bar',
                height: 350,
                stacked: true,
            },
            toolbar: {
                show: false,
            },
            responsive: [
                {
                    breakpoint: 480,
                    options: {
                        legend: {
                            position: 'bottom',
                            offsetX: -10,
                            offsetY: 0,
                        },
                    },
                },
            ],
            dataLabel: {
                enabled: true,

            },
            plotOptions: {
                bar: {
                    horizontal: false,
                    borderRadius: 10,
                    dataLabels: {
                        total: {
                            enabled: true,
                            formatter: function (val: number, opts: any) {
                              return "Mini:" + props.min[opts.seriesIndex] + "h "+ "Max:" + props.max[opts.seriesIndex] + "h";
                            },
                            style: {
                                fontSize: '13px',
                                fontWeight: 900,
                            },
                        },
                    },
                },
            },
            xaxis: {
                type: 'datetime',
                categories: [
                    '01/01/2011 GMT',
                    '01/02/2011 GMT',
                    '01/03/2011 GMT',
                    '01/04/2011 GMT',
                    '01/05/2011 GMT',
                    '01/06/2011 GMT',
                ],
            },
            legend: {
                position: 'right',
                offsetY: 40,
            },
            fill: {
                opacity: 1,
            },
            grid: {
                borderColor: '#f1f1f1',
            },
        };

        onMounted(() => {
            chart.value = new ApexCharts(document.querySelector('#chart')!, options);
            chart.value.render();
        });

        return {};
    },
});
</script>
  