﻿#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	//Пропускаем инициализацию, чтобы гарантировать получение формы при передаче параметра "АвтоТест".
	Если Параметры.Свойство("АвтоТест") Тогда
		Возврат;
	КонецЕсли;
	
	ВидРабочегоЦентра = Параметры.ВидРабочегоЦентра;
	ДатаГрафика = Параметры.ДатаГрафика;
	ГрафикРаботыРабочегоЦентра = Параметры.ГрафикРаботыРабочегоЦентра;
	ВнесеныРучныеИзменения = Параметры.ВнесеныРучныеИзменения;
	АдресДанныхГрафикиРаботыРЦ = Параметры.АдресДанныхГрафикиРаботыРЦ;
	
	Если Параметры.ДанныеИзменены Тогда
		РасписаниеГрафиковРаботыРЦ = ПолучитьИзВременногоХранилища(АдресДанныхГрафикиРаботыРЦ);
		СтруктураПоиска = Новый Структура("РабочийЦентр,ДатаГрафика", Параметры.РабочийЦентр, ДатаГрафика);
		РасписаниеНаДатуГрафика = РасписаниеГрафиковРаботыРЦ.НайтиСтроки(СтруктураПоиска);
	Иначе
		РасписаниеНаДатуГрафика = РасписаниеНаДатуГрафика(Параметры.РабочийЦентр, ДатаГрафика);
	КонецЕсли; 
	
	Для каждого РасписаниеДня Из РасписаниеНаДатуГрафика Цикл
		Если РасписаниеДня.Количество <> 0 Тогда
			СтрокаИнтервал = Интервалы.Добавить();
			СтрокаИнтервал.ВремяНачала    = РасписаниеДня.ВремяНачала;
			СтрокаИнтервал.ВремяОкончания = РасписаниеДня.ВремяОкончания;
		КонецЕсли; 
	КонецЦикла;
	
	Интервалы.Сортировать("ВремяНачала");
	
	ОпределитьСуммарноеВремяРаботы(ЭтаФорма);

	Если Параметры.ТолькоПросмотрГрафика Тогда
		Элементы.Интервалы.ТолькоПросмотр = Истина;
		Элементы.ДатыГрафикаЗаполнитьПоГрафикуРаботы.Видимость = Ложь;
		Элементы.Интервалы.ПоложениеКоманднойПанели = ПоложениеКоманднойПанелиЭлементаФормы.Нет;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытием(Отказ, ЗавершениеРаботы, ТекстПредупреждения, СтандартнаяОбработка)
	
	Если Модифицированность Тогда
		
		СтандартнаяОбработка = Ложь;
		
		ОповещениеЗакрытия = Новый ОписаниеОповещения("ПередЗакрытиемЗавершение", ЭтотОбъект);
		ТекстВопроса = НСтр("ru = 'Данные были изменены. Сохранить изменения?'");
		
		ОбщегоНазначенияКлиент.ПоказатьПодтверждениеЗакрытияФормы(ОповещениеЗакрытия, Отказ, ЗавершениеРаботы, ТекстВопроса,
			ТекстПредупреждения);
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("СправочникСсылка.Календари") Тогда
		ЗаполнитьПоГрафикуРаботыНаСервере(ВыбранноеЗначение);
		ВнесеныРучныеИзменения = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыИнтервалы

&НаКлиенте
Процедура ИнтервалыПриОкончанииРедактирования(Элемент, НоваяСтрока, ОтменаРедактирования)
	
	Если ОтменаРедактирования Тогда
		Возврат;
	КонецЕсли;
	
	ОпределитьСуммарноеВремяРаботы(ЭтаФорма);
	
	ГрафикиРаботыКлиентСервер.ВосстановитьПорядокСтрокКоллекцииПослеРедактирования(Интервалы, "ВремяНачала", Элемент.ТекущиеДанные);
	
КонецПроцедуры

&НаКлиенте
Процедура ИнтервалыПриИзменении(Элемент)

	ВнесеныРучныеИзменения = Истина;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура КомандаЗаполнитьПоГрафикуРаботы(Команда)
	
	Если ГрафикРаботыРабочегоЦентра.Пустая() Тогда
		ПараметрыФормы = Новый Структура;
		ПараметрыФормы.Вставить("РежимВыбора", Истина);
		ОписаниеОповещения = Новый ОписаниеОповещения("ЗаполнитьПоГрафикуРаботыЗавершение", ЭтотОбъект);
		ОткрытьФорму("Справочник.Календари.ФормаВыбора", 
						ПараметрыФормы, 
						ЭтаФорма,,,, 
						ОписаниеОповещения, 
						РежимОткрытияОкнаФормы.БлокироватьОкноВладельца);
	Иначе
		ЗаполнитьПоГрафикуРаботыНаСервере(ГрафикРаботыРабочегоЦентра);
		ВнесеныРучныеИзменения = Ложь;
	КонецЕсли; 
	
КонецПроцедуры

&НаКлиенте
Процедура КомандаОК(Команда)
	
	ЗавершитьРедактирование();
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаКлиентеНаСервереБезКонтекста
Процедура ОпределитьСуммарноеВремяРаботы(Форма)

	Секунд = 0;
	Для каждого СтрокаИнтервал Из Форма.Интервалы Цикл
		Если Не ЗначениеЗаполнено(СтрокаИнтервал.ВремяОкончания) 
			ИЛИ СтрокаИнтервал.ВремяОкончания = '000101012359' Тогда
			СекундИнтервала = КонецДня(СтрокаИнтервал.ВремяОкончания) - СтрокаИнтервал.ВремяНачала + 1;
		Иначе
			СекундИнтервала = НачалоМинуты(СтрокаИнтервал.ВремяОкончания) - СтрокаИнтервал.ВремяНачала;
		КонецЕсли;
		Секунд = Секунд + СекундИнтервала;
	КонецЦикла;

	Форма.СуммарноеВремяРаботы = Секунд / 3600;

КонецПроцедуры

&НаКлиенте
Процедура ЗаполнитьПоГрафикуРаботыЗавершение(РезультатЗакрытия, ДополнительныеПараметры) Экспорт

	Если РезультатЗакрытия <> Неопределено Тогда
		ЗаполнитьПоГрафикуРаботыНаСервере(РезультатЗакрытия);
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ЗаполнитьПоГрафикуРаботыНаСервере(ГрафикРаботы)
	
	Интервалы.Очистить();
	
	РасписанияРаботыНаПериод = ПланированиеПроизводства.РасписаниеРаботыПоГрафику(ГрафикРаботы, НачалоДня(ДатаГрафика), КонецДня(ДатаГрафика));
	Для каждого СтрокаРасписание Из РасписанияРаботыНаПериод Цикл
		СтрокаИнтервал = Интервалы.Добавить();
		ЗаполнитьЗначенияСвойств(СтрокаИнтервал, СтрокаРасписание);
	КонецЦикла; 
	
	ОпределитьСуммарноеВремяРаботы(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПередЗакрытиемЗавершение(РезультатВопроса, ДополнительныеПараметры) Экспорт
	
	Если РезультатВопроса = КодВозвратаДиалога.Да Тогда
		ЗавершитьРедактирование();
	ИначеЕсли РезультатВопроса = КодВозвратаДиалога.Нет Тогда
		Модифицированность = Ложь;
		Закрыть();
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ЗавершитьРедактирование()

	ОчиститьСообщения();
	
	РасписаниеДня = РасписаниеДня();
	Если РасписаниеДня = Неопределено Тогда
		Возврат;
	КонецЕсли;
	
	РезультатРедактирования = Новый Структура;
	РезультатРедактирования.Вставить("ВнесеныРучныеИзменения", ВнесеныРучныеИзменения);
	РезультатРедактирования.Вставить("РасписаниеДня", РасписаниеДня);
	
	Модифицированность = Ложь;
	
	Закрыть(РезультатРедактирования);

КонецПроцедуры

&НаКлиенте
Функция РасписаниеДня()
	
	Отказ = Ложь;
	
	РасписаниеДня = Новый Массив;
	
	ОкончаниеДня = Неопределено;
	
	Для Каждого СтрокаРасписания Из Интервалы Цикл
		ИндексСтроки = Интервалы.Индекс(СтрокаРасписания);
		Если СтрокаРасписания.ВремяНачала > СтрокаРасписания.ВремяОкончания 
			И ЗначениеЗаполнено(СтрокаРасписания.ВремяОкончания) Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Время начала больше времени окончания'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Интервалы[%1].ВремяОкончания", ИндексСтроки), ,
				Отказ);
		КонецЕсли;
		Если СтрокаРасписания.ВремяНачала = СтрокаРасписания.ВремяОкончания Тогда
			ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
				НСтр("ru = 'Длительность интервала не определена'"), ,
				СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Интервалы[%1].ВремяОкончания", ИндексСтроки), ,
				Отказ);
		КонецЕсли;
		Если ОкончаниеДня <> Неопределено Тогда
			Если ОкончаниеДня > СтрокаРасписания.ВремяНачала 
				Или Не ЗначениеЗаполнено(ОкончаниеДня) Тогда
				ОбщегоНазначенияКлиентСервер.СообщитьПользователю(
					НСтр("ru = 'Обнаружены пересекающиеся интервалы'"), ,
					СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку("Интервалы[%1].ВремяНачала", ИндексСтроки), ,
					Отказ);
			КонецЕсли;
		КонецЕсли;
		ОкончаниеДня = СтрокаРасписания.ВремяОкончания;
		
		Если Не ЗначениеЗаполнено(СтрокаРасписания.ВремяОкончания) 
			ИЛИ СтрокаРасписания.ВремяОкончания = '000101012359'
			ИЛИ СтрокаРасписания.ВремяОкончания = '00010101235959' Тогда
			Длительность = КонецДня(СтрокаРасписания.ВремяОкончания) - СтрокаРасписания.ВремяНачала + 1;
		Иначе
			Длительность = СтрокаРасписания.ВремяОкончания - СтрокаРасписания.ВремяНачала;
		КонецЕсли;
		
		РасписаниеДня.Добавить(Новый Структура("ВремяНачала, ВремяОкончания, Длительность", 
								СтрокаРасписания.ВремяНачала, СтрокаРасписания.ВремяОкончания, Длительность));
	КонецЦикла;
	
	Если Отказ Тогда
		Возврат Неопределено;
	КонецЕсли;
	
	Возврат РасписаниеДня;
	
КонецФункции

&НаСервере
Функция РасписаниеНаДатуГрафика(РабочийЦентр, ДатаГрафика)

	Запрос = Новый Запрос;
	Запрос.Текст = 
	"ВЫБРАТЬ
	|	ДоступностьРабочихЦентровИнтервалы.ВремяНачала КАК ВремяНачала,
	|	ДоступностьРабочихЦентровИнтервалы.ВремяОкончания КАК ВремяОкончания,
	|	ДоступностьРабочихЦентровИнтервалы.Количество
	|ИЗ
	|	Документ.ДоступностьРабочихЦентров.Интервалы КАК ДоступностьРабочихЦентровИнтервалы
	|ГДЕ
	|	ДоступностьРабочихЦентровИнтервалы.Ссылка.Проведен
	|	И ДоступностьРабочихЦентровИнтервалы.РабочийЦентр = &РабочийЦентр
	|	И ДоступностьРабочихЦентровИнтервалы.ДатаГрафика = &ДатаГрафика";
	
	Запрос.УстановитьПараметр("РабочийЦентр", РабочийЦентр);
	Запрос.УстановитьПараметр("ДатаГрафика", ДатаГрафика);
	
	РасписаниеНаДатуГрафика = Запрос.Выполнить().Выгрузить();

	Возврат РасписаниеНаДатуГрафика;

КонецФункции

#КонецОбласти
