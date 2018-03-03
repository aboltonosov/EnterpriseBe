﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	Сотрудник = Параметры.Сотрудник;
	Показатель = Параметры.Показатель;
	
	Для каждого ЗначениеПоказателя Из Параметры.ЗначенияПоказателя Цикл
		ЗаполнитьЗначенияСвойств(ЗначенияПоказателя.Добавить(), ЗначениеПоказателя);
	КонецЦикла;
	
	Если ТипЗнч(Показатель) = Тип("СправочникСсылка.ПоказателиРасчетаЗарплаты") Тогда
		ПоказательИнфо = ЗарплатаКадрыРасширенный.СведенияОПоказателеРасчетаЗарплаты(Показатель);
		Элементы.ЗначенияПоказателяЗначение.ОграничениеТипа = ПоказательИнфо.ТипПоказателя;
		Элементы.ЗначенияПоказателяЗначение.Формат = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("ЧДЦ=%1", ПоказательИнфо["Точность"]);
	Иначе
		Элементы.ЗначенияПоказателяЗначение.ОграничениеТипа = Новый ОписаниеТипов("Число");
		Элементы.ЗначенияПоказателяЗначение.Формат = "ЧДЦ=2";
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура OK(Команда)
	
	РезультатРедактирования = Неопределено;
	Если Модифицированность Тогда
		РезультатРедактирования = РезультатРедактирования();
	КонецЕсли; 
	
	Закрыть(РезультатРедактирования);
	
КонецПроцедуры

&НаКлиенте
Процедура Отмена(Команда)
	
	Закрыть();
	
КонецПроцедуры

&НаКлиенте
Функция РезультатРедактирования()
	
	РезультатРедактирования = Новый Структура;
	
	РезультатРедактирования.Вставить("Сотрудник", Сотрудник);
	РезультатРедактирования.Вставить("Показатель", Показатель);
	
	РезультатЗначенияПоказателя = Новый Массив;
	Для каждого ЗначениеПоказателя Из ЗначенияПоказателя Цикл
		РезультатЗначенияПоказателя.Добавить(Новый ФиксированнаяСтруктура(Новый Структура("ДокументОснование,Значение", ЗначениеПоказателя.ДокументОснование, ЗначениеПоказателя.Значение)))
	КонецЦикла;
	
	РезультатРедактирования.Вставить("ЗначенияПоказателя", Новый ФиксированныйМассив(РезультатЗначенияПоказателя));
	
	Возврат РезультатРедактирования;
	
КонецФункции

#КонецОбласти
