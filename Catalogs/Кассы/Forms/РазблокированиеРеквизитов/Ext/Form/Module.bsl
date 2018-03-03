﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	РазрешитьРедактированиеВалютаДенежныхСредств = Истина;
	РазрешитьРедактированиеКассовойКниги = Истина;
	//++ НЕ УТ
	РазрешитьРедактированиеСчетаУчета = Истина;
	//-- НЕ УТ

	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура РазрешитьРедактирование(Команда)

	Результат = Новый Массив;
	Если РазрешитьРедактированиеВалютаДенежныхСредств Тогда
		Результат.Добавить("ВалютаДенежныхСредств");
	КонецЕсли;
	Если РазрешитьРедактированиеКассовойКниги Тогда
		Результат.Добавить("ПризнакКассовойКнигиОбособленногоПодразделения");
	КонецЕсли;
	//++ НЕ УТ
	Если РазрешитьРедактированиеСчетаУчета Тогда
		Результат.Добавить("СчетУчета");
	КонецЕсли;
	//-- НЕ УТ

	Закрыть(Результат);
	
КонецПроцедуры

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

#КонецОбласти
