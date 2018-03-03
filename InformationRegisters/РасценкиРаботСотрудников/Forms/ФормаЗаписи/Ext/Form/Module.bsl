﻿
&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ВалютаРасценокВидовРабот = Константы.ВалютаРасценокВидовРабот.Получить();
	
	Если ЗначениеЗаполнено(ВалютаРасценокВидовРабот) Тогда
		Элементы.НадписьВалютаНеЗадана.Видимость = Ложь;
	Иначе
		Элементы.НадписьВалютаНеЗадана.Заголовок = НСтр("ru = 'Валюта расценок на виды работ не задана. Валюта задается в разделе администрирования производства.'");
		Элементы.ВалютаРасценокВидовРабот.Видимость = Ложь;
	КонецЕсли;
	
КонецПроцедуры
