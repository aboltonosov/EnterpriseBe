﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	СтруктураСчетов = Параметры.СтруктураСчетов;
	Организация = Параметры.Организация;
	
	Если ЗначениеЗаполнено(Организация) Тогда
		ПараметрыФО = Новый Структура;
		ПараметрыФО.Вставить("Организация", Организация);
		ПрименяетсяЕНВД = ПолучитьФункциональнуюОпцию("ПлательщикЕНВД", ПараметрыФО);
	Иначе
		ПрименяетсяЕНВД = ПолучитьФункциональнуюОпцию("ИспользуетсяЕНВД");
	КонецЕсли;

	УправлениеЭлементамиФормы();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура СохранитьИЗакрыть(Команда)
	
	ЗаполнитьЗначенияСвойств(СтруктураСчетов, ЭтаФорма);
	Закрыть(СтруктураСчетов);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

#Область Прочее

&НаСервере
Процедура УправлениеЭлементамиФормы()
	
	МассивВсехРеквизитов = Новый Массив;
	МассивВсехРеквизитов.Добавить("СчетУчетаНаСкладе");
	МассивВсехРеквизитов.Добавить("СчетУчетаПередачиНаКомиссию");
	МассивВсехРеквизитов.Добавить("СчетУчетаВыручкиОтПродаж");
	МассивВсехРеквизитов.Добавить("СчетУчетаСебестоимостиПродаж");
	МассивВсехРеквизитов.Добавить("СчетУчетаНДСПриПродаже");
	МассивВсехРеквизитов.Добавить("СчетУчетаВПути");
	МассивВсехРеквизитов.Добавить("СчетУчетаНДСВПути");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаАвансовВыданных");
	МассивВсехРеквизитов.Добавить("СчетУчетаАвансовПолученных");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовПоВознаграждению");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовПоПретензиям");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСКлиентами");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСКлиентамиТара");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСПоставщиками");
	МассивВсехРеквизитов.Добавить("СчетУчетаРасчетовСПоставщикамиТара");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаДоходов");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаРасходов");
	МассивВсехРеквизитов.Добавить("СчетСписанияОСНО");
	МассивВсехРеквизитов.Добавить("СчетСписанияЕНВД");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаТМЦВЭксплуатации");
	МассивВсехРеквизитов.Добавить("СчетЗабалансовогоУчета");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаПодарочныхСертификатов");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаДенежныхСредств");
	
	МассивВсехРеквизитов.Добавить("СчетУчетаПроизводства");
	
	МассивРеквизитовОперации = Новый Массив;
	Для Каждого КлючИЗначение Из СтруктураСчетов Цикл
		МассивРеквизитовОперации.Добавить(КлючИЗначение.Ключ);
		Элементы[КлючИЗначение.Ключ].ПараметрыВыбора = КлючИЗначение.Значение;
	КонецЦикла;
	
	ДенежныеСредстваСервер.УстановитьВидимостьЭлементовПоМассиву(
		Элементы,
		МассивВсехРеквизитов,
		МассивРеквизитовОперации);
		
	Элементы.СчетСписанияЕНВД.Видимость = Элементы.СчетСписанияЕНВД.Видимость И ПрименяетсяЕНВД;
	
	Если ПрименяетсяЕНВД Тогда
		Элементы.СчетСписанияОСНО.Заголовок = НСтр("ru='Счет списания (ОСНО)'");
	Иначе
		Элементы.СчетСписанияОСНО.Заголовок = НСтр("ru='Счет списания'");
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетУчетаРасходовПриИзменении(Элемент)
	
	СчетУчетаРасходовПриИзмененииСервер();
	
КонецПроцедуры

&НаСервере
Процедура СчетУчетаРасходовПриИзмененииСервер()
	
	Если ЗначениеЗаполнено(СчетУчетаРасходов) Тогда
		
		ЭтоСчет90или91 = (РеглУчетВыборкиСерверПовтИсп.Счета90и91().НайтиПоЗначению(СчетУчетаРасходов) <> Неопределено); 
		
		Если ЭтоСчет90или91 Тогда
			СчетСписанияОСНО = Неопределено;
			Если ПрименяетсяЕНВД Тогда
				СчетСписанияЕНВД = Неопределено;
			КонецЕсли;
		ИначеЕсли СчетУчетаРасходов = ПланыСчетов.Хозрасчетный.РасходыНаПродажу
			 Или СчетУчетаРасходов = ПланыСчетов.Хозрасчетный.ИздержкиОбращения
			 Или СчетУчетаРасходов = ПланыСчетов.Хозрасчетный.КоммерческиеРасходы Тогда
			СчетСписанияОСНО = ПланыСчетов.Хозрасчетный.Продажи_РасходыНаПродажуНеЕНВД;
			Если ПрименяетсяЕНВД Тогда
				СчетСписанияЕНВД = ПланыСчетов.Хозрасчетный.Продажи_РасходыНаПродажуЕНВД;
			КонецЕсли;
		Иначе
			СчетСписанияОСНО = ПланыСчетов.Хозрасчетный.Продажи_УправленческиеРасходыНеЕНВД;
			Если ПрименяетсяЕНВД Тогда
				СчетСписанияЕНВД = ПланыСчетов.Хозрасчетный.Продажи_УправленческиеРасходыЕНВД;
			КонецЕсли;
		КонецЕсли;
		
		Элементы.СчетСписанияОСНО.Доступность = НЕ ЭтоСчет90или91;
		Если ПрименяетсяЕНВД Тогда
			Элементы.СчетСписанияЕНВД.Доступность = НЕ ЭтоСчет90или91;
		КонецЕсли;
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#КонецОбласти
