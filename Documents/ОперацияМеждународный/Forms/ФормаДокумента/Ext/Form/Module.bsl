﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)

	УстановитьУсловноеОформление();

	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	ОбновлениеИнформационнойБазы.ПроверитьОбъектОбработан(Объект, ЭтотОбъект);
	
	Элементы.Период.Видимость = Объект.ВводитьПериодПострокам;
	
	МеждународныйУчетОбщегоНазначения.УстановитьЗаголовкиПодразделения(Элементы.ПодразделениеДт, Элементы.ПодразделениеКт);
	// обновить подписи валют
	ВалютаМУ = МеждународнаяОтчетностьВызовСервера.УчетнаяВалюта();
	
	Текст = СтрШаблон(НСтр("ru='Функц. (%1)'"), Строка(ВалютаМУ.Функциональная));
	Элементы.Сумма.Заголовок = Текст;
	
	Текст = СтрШаблон(НСтр("ru='Пред. (%1)'"), Строка(ВалютаМУ.Представления));
	Элементы.СуммаПредставления.Заголовок = Текст;
	
	Если ВалютаМУ.Функциональная = ВалютаМУ.Представления Тогда
		Элементы.СуммаПредставления.Видимость = Ложь;
		Текст = СтрШаблон(НСтр("ru='Сумма (%1)'"), Строка(ВалютаМУ.Функциональная));
		Элементы.Сумма.Заголовок = Текст;
	КонецЕсли;
	
	ТекстВвестиДокумент = НСтр("ru = 'Ввести документ'");
	
	ФлажокСписок = Объект.ЗаполнениеДвижений.Количество() > 1;
	МассивТиповДокумента = Новый Массив;
	СоответствиеДоступныхТипов = ОбщегоНазначенияПовтИсп.ДоступностьОбъектовПоОпциям();
	Для каждого Тип из Метаданные.РегистрыБухгалтерии.Международный.СтандартныеРеквизиты.Регистратор.Тип.Типы() Цикл
		Если Не СоответствиеДоступныхТипов.Получить(Метаданные.НайтиПоТипу(Тип).ПолноеИмя()) = Ложь Тогда
			МассивТиповДокумента.Добавить(Тип);
		КонецЕсли;
	КонецЦикла;
	МассивТиповДокумента.Добавить(Тип("Строка"));
	НовыйТип = Новый ОписаниеТипов(МассивТиповДокумента);
	Элементы.СторнируемыйДокумент.ОграничениеТипа = НовыйТип;
	
	ОбновлениеОтображения();
	
	// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	ДополнительныеОтчетыИОбработки.ПриСозданииНаСервере(ЭтаФорма);
	// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
	
	СобытияФорм.ПриСозданииНаСервере(ЭтаФорма, Отказ, СтандартнаяОбработка);

	// ВводНаОсновании
	ВводНаОсновании.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюСоздатьНаОсновании);
	// Конец ВводНаОсновании

	// МенюОтчеты
	МенюОтчеты.ПриСозданииНаСервере(ЭтотОбъект, Элементы.ПодменюОтчеты);
	// Конец МенюОтчеты

КонецПроцедуры

&НаСервере
Процедура ПриЧтенииНаСервере(ТекущийОбъект)
	
	ДатыЗапретаИзменения.ОбъектПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);
	
	МеждународныйУчетОбщегоНазначения.ЗаполнитьПредставлениеВидовСубконто(Объект.Движения.Международный);

	МодификацияКонфигурацииПереопределяемый.ПриЧтенииНаСервере(ЭтаФорма, ТекущийОбъект);

КонецПроцедуры

&НаКлиенте
Процедура ОбработкаВыбора(ВыбранноеЗначение, ИсточникВыбора)
	
	Если ТипЗнч(ВыбранноеЗначение) = Тип("Структура") Тогда
		Если ВыбранноеЗначение.Свойство("АдресПроводокВХранилище") Тогда
			ЗагрузитьПроводкиИзХранилища(ВыбранноеЗначение.АдресПроводокВХранилище);
			Модифицированность = Истина;
		ИначеЕсли ВыбранноеЗначение.Свойство("ШаблонОперации") Тогда
			ИменаШаблонов = ОбоработкаВыбораШаблонаОперацииСервер(ВыбранноеЗначение.ШаблонОперации);
			ПоказатьОповещениеПользователя(НСтр("ru='Добавлены типовые проводки:'"),,ИменаШаблонов,БиблиотекаКартинок.Информация32);
		КонецЕсли;
	ИначеЕсли Элементы.СторнируемыйДокумент.ОграничениеТипа.СодержитТип(ТипЗнч(ВыбранноеЗначение)) Тогда
		СторнируемыйДокумент = ВыбранноеЗначение;
		ЗагрузитьПроводкиДляСторнирования(ВыбранноеЗначение);
	КонецЕсли;
	
	Если Окно <> Неопределено Тогда
		Окно.Активизировать();
	КонецЕсли;
	
КонецПроцедуры

&НаСервере
Процедура ПослеЗаписиНаСервере(ТекущийОбъект, ПараметрыЗаписи)
	
	Если ПараметрыЗаписи.РежимЗаписи = РежимЗаписиДокумента.ОтменаПроведения Тогда
		ЭтаФорма.Прочитать();
	КонецЕсли;
	МеждународныйУчетОбщегоНазначения.ЗаполнитьПредставлениеВидовСубконто(Объект.Движения.Международный);
	
	МодификацияКонфигурацииПереопределяемый.ПослеЗаписиНаСервере(ЭтаФорма, ТекущийОбъект, ПараметрыЗаписи);
	
КонецПроцедуры

&НаКлиенте
Процедура ПослеЗаписи(ПараметрыЗаписи)

	МодификацияКонфигурацииКлиентПереопределяемый.ПослеЗаписи(ЭтаФорма, ПараметрыЗаписи);

КонецПроцедуры

&НаСервере
Процедура ПередЗаписьюНаСервере(Отказ, ТекущийОбъект, ПараметрыЗаписи)

	Если НЕ ФлажокСписок И ЗначениеЗаполнено(СторнируемыйДокумент) И ТипЗнч(СторнируемыйДокумент) <> Тип("Строка") Тогда
		ТекущийОбъект.ЗаполнениеДвижений.Очистить();
		НоваяСтрока = ТекущийОбъект.ЗаполнениеДвижений.Добавить();
		НоваяСтрока.Документ = СторнируемыйДокумент;
	КонецЕсли;
	МодификацияКонфигурацииПереопределяемый.ПередЗаписьюНаСервере(ЭтаФорма, Отказ, ТекущийОбъект, ПараметрыЗаписи);

КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовШапкиФормы

&НаКлиенте
Процедура ВводитьПериодПоСтрокамПриИзменении(Элемент)
	
	Элементы.Период.Видимость = Объект.ВводитьПериодПострокам;
	
КонецПроцедуры

&НаКлиенте
Процедура СпособЗаполненияПриИзменении(Элемент)
	
	ОбновлениеОтображения();
	
КонецПроцедуры

&НаКлиенте
Процедура КомментарийНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ОбщегоНазначенияКлиент.ПоказатьФормуРедактированияКомментария(
		Элемент.ТекстРедактирования, 
		ЭтотОбъект, 
		"Объект.Комментарий");
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовЗаполнениеДвижений

&НаКлиенте
Процедура ЗаполнениеДвиженийДокументНачалоВыбора(Элемент, ДанныеВыбора, СтандартнаяОбработка)
	
	ТекущиеДанные = Элементы.ЗаполнениеДвижений.ТекущиеДанные;
	Элемент.ВыбиратьТип = НЕ ЗначениеЗаполнено(ТекущиеДанные.Документ);
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовТаблицыФормыДвижениямеждународный

&НаКлиенте
Процедура ДвиженияМеждународныйПриНачалеРедактирования(Элемент, НоваяСтрока, Копирование)
	
	ТекущаяСтрока = Элементы.ДвиженияМеждународный.ТекущиеДанные;
	Если НоваяСтрока И НЕ Копирование Тогда
		ТекущаяСтрока.Активность = Ложь;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура СчетДтПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДвиженияМеждународный.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПредставлениеВидовСубконтоСчета(ТекущиеДанные.СчетДт, "Дт"));
	
КонецПроцедуры

&НаКлиенте
Процедура СчетКтПриИзменении(Элемент)
	
	ТекущиеДанные = Элементы.ДвиженияМеждународный.ТекущиеДанные;
	ЗаполнитьЗначенияСвойств(ТекущиеДанные, ПредставлениеВидовСубконтоСчета(ТекущиеДанные.СчетКт, "Кт"));
	
КонецПроцедуры

&НаКлиенте
Процедура СуммаПриИзменении(Элемент)
	
	ТекущаяСтрока = Элементы.ДвиженияМеждународный.ТекущиеДанные;
	ТекущаяСтрока.СуммаПредставления = РасчитатьСуммуПредставления(ТекущаяСтрока.Сумма, Объект.Дата);
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаДтПриИзменении(Элемент)
	
	ВалютаПриИзменении("Дт");
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютаКтПриИзменении(Элемент)
	
	ВалютаПриИзменении("Кт");
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютнаяСуммаДтПриИзменении(Элемент)
	
	ВалютаПриИзменении("Дт");
	
КонецПроцедуры

&НаКлиенте
Процедура ВалютнаяСуммаКтПриИзменении(Элемент)
	
	ВалютаПриИзменении("Кт");
	
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Дт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт1ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Дт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт2ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Дт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоДт3ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Кт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт1ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Кт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт2ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3ПриИзменении(Элемент)
	ИзменитьПараметрыВыбораПолейСубконто(ЭтотОбъект, "Кт");
КонецПроцедуры

&НаКлиенте
Процедура СубконтоКт3ОбработкаВыбора(Элемент, ВыбранноеЗначение, СтандартнаяОбработка)
	ОчиститьПараметрыВыбора(Элемент);
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

// ВводНаОсновании
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуСоздатьНаОсновании(Команда)
	
	ВводНаОснованииКлиент.ВыполнитьПодключаемуюКомандуСоздатьНаОсновании(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец ВводНаОсновании

// МенюОтчеты
&НаКлиенте
Процедура Подключаемый_ВыполнитьКомандуОтчет(Команда)
	
	МенюОтчетыКлиент.ВыполнитьПодключаемуюКомандуОтчет(Команда, ЭтотОбъект, Объект);
	
КонецПроцедуры
// Конец МенюОтчеты

&НаКлиенте
Процедура ЗагрузитьПроводки(Команда)
	
	НачатьЗагрузкуПроводок(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗагрузитьПроводкиСторно(Команда)
	
	НачатьЗагрузкуПроводок(Команда.Имя);
	
КонецПроцедуры

&НаКлиенте
Процедура ДобавитьПоШаблону(Команда)
	
	ПараметрыФормы = Новый Структура("Объект",Объект);
	ОткрытьФорму("Справочник.ТиповыеОперацииМеждународныйУчет.ФормаВыбора", ПараметрыФормы, ЭтаФорма);
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаКлиенте
Процедура Подключаемый_ВыполнитьНазначаемуюКоманду(Команда)
	Если НЕ ДополнительныеОтчетыИОбработкиКлиент.ВыполнитьНазначаемуюКомандуНаКлиенте(ЭтаФорма, Команда.Имя) Тогда
		РезультатВыполнения = Неопределено;
		ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(Команда.Имя, РезультатВыполнения);
		
	КонецЕсли;
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаКлиенте
Процедура Подключаемый_ВыполнитьПереопределяемуюКоманду(Команда)
	
	СобытияФормКлиент.ВыполнитьПереопределяемуюКоманду(ЭтаФорма, Команда);
	
КонецПроцедуры

&НаКлиенте
Процедура ЗаписатьДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Записать(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиДокумент(Команда)
	
	ОбщегоНазначенияУТКлиент.Провести(ЭтаФорма);
	
КонецПроцедуры

&НаКлиенте
Процедура ПровестиИЗакрыть(Команда)
	
	ОбщегоНазначенияУТКлиент.ПровестиИЗакрыть(ЭтаФорма);
	
КонецПроцедуры

#КонецОбласти

#Область СлужебныеПроцедурыИФункции

&НаСервере
Процедура УстановитьУсловноеОформление()

	УсловноеОформление.Элементы.Очистить();

	// оформление отрицательных сумм красным
	ОформлениеОтрицательныхСумм("Сумма");
	ОформлениеОтрицательныхСумм("СуммаПредставления");
	ОформлениеОтрицательныхСумм("ВалютнаяСуммаДт");
	ОформлениеОтрицательныхСумм("ВалютнаяСуммаКт");
	
	// оформление полей "Субконто1", ... и т.д.
	МеждународныйУчетОбщегоНазначения.УстановитьОформлениеПроводок(УсловноеОформление, "Объект.Движения.Международный");
	
КонецПроцедуры

&НаСервере
Процедура ОформлениеОтрицательныхСумм(ИмяПоля)

	Элемент = УсловноеОформление.Элементы.Добавить();

	ПолеЭлемента = Элемент.Поля.Элементы.Добавить();
	ПолеЭлемента.Поле = Новый ПолеКомпоновкиДанных(ИмяПоля);

	ОтборЭлемента = Элемент.Отбор.Элементы.Добавить(Тип("ЭлементОтбораКомпоновкиДанных"));
	ОтборЭлемента.ЛевоеЗначение = Новый ПолеКомпоновкиДанных("Объект.Движения.Международный."+ИмяПоля);
	ОтборЭлемента.ВидСравнения = ВидСравненияКомпоновкиДанных.Меньше;
	ОтборЭлемента.ПравоеЗначение = 0;
	Элемент.Оформление.УстановитьЗначениеПараметра("ЦветТекста", ЦветаСтиля.ЦветОтрицательногоЧисла);

КонецПроцедуры

&НаСервере
Процедура ОбновлениеОтображения()
	
	Элементы.ГруппаСторнироватьСписок.Видимость = Ложь;
	Если Объект.ЗаполнениеДвижений.Количество() > 1 Тогда
		Элементы.ГруппаСторнироватьСписок.Видимость = Истина;
		Элементы.СтраницыСторнирования.ТекущаяСтраница = Элементы.ГруппаСторнироватьСписок;
		СторнируемыйДокумент = Неопределено;
		СторнируемыйДокумент = ТекстВвестиДокумент;
		
	ИначеЕсли Объект.ЗаполнениеДвижений.Количество() = 1 Тогда
		Элементы.СтраницыСторнирования.ТекущаяСтраница = Элементы.ГруппаСторнироватьДокумент;
		СторнируемыйДокумент = Объект.ЗаполнениеДвижений[0].Документ;
		
	Иначе
		Элементы.СтраницыСторнирования.ТекущаяСтраница = Элементы.ГруппаСторнироватьДокумент;
		СторнируемыйДокумент = ТекстВвестиДокумент;
		
	КонецЕсли;

КонецПроцедуры

&НаКлиенте
Процедура НачатьЗагрузкуПроводок(ИмяКоманды)
	
	Если Объект.Движения.Международный.Количество() > 0 Тогда
		ПоказатьВопрос(Новый ОписаниеОповещения("ОбработкаОтветаНаВопросЕстьСтроки", ЭтотОбъект, ИмяКоманды),
						НСтр("ru='""Список проводок"" уже содержит строки.
							|При заполнении они будут удалены!
							|Продолжить?'"),
							РежимДиалогаВопрос.ДаНет);
	Иначе
		ВыполнитьЗагрузкуПроводок(ИмяКоманды);
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработкаОтветаНаВопросЕстьСтроки(Ответ, ИмяКоманды) Экспорт
	
	Если Ответ = КодВозвратаДиалога.Нет Тогда
		Возврат;
	КонецЕсли;
	
	ВыполнитьЗагрузкуПроводок(ИмяКоманды);
	
КонецПроцедуры

&НаКлиенте
Процедура ВыполнитьЗагрузкуПроводок(ИмяКоманды)
	
	Если ИмяКоманды = "ЗагрузитьПроводки" Тогда
		ПараметрыФормы = Новый Структура("ДатаДокумента, Организация", Объект.Дата, Объект.Организация);
		ОткрытьФорму("Документ.ОперацияМеждународный.Форма.ФормаЗагрузки", ПараметрыФормы, ЭтаФорма);
	ИначеЕсли ИмяКоманды = "ЗагрузитьПроводкиСторно" Тогда
		ЗагрузитьПроводкиСторноНаСервере();
	КонецЕсли;
	
КонецПроцедуры

// СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки
&НаСервере
Процедура ДополнительныеОтчетыИОбработкиВыполнитьНазначаемуюКомандуНаСервере(ИмяЭлемента, РезультатВыполнения)
	ДополнительныеОтчетыИОбработки.ВыполнитьНазначаемуюКомандуНаСервере(ЭтаФорма, ИмяЭлемента, РезультатВыполнения);
КонецПроцедуры
// Конец СтандартныеПодсистемы.ДополнительныеОтчетыИОбработки

&НаСервереБезКонтекста
Функция РасчитатьСуммуПредставления(Сумма, Дата)
	
	Возврат МеждународныйУчетОбщегоНазначения.РасчитатьСуммуПредставления(Сумма, Дата);
	
КонецФункции

&НаКлиенте
Процедура ВалютаПриИзменении(ДтКт)
	
	ТекущаяСтрока = Элементы.ДвиженияМеждународный.ТекущиеДанные;
	НаДату = ?(Объект.ВводитьПериодПоСтрокам, ТекущаяСтрока.Период, Объект.Дата);
	СуммыПроводки = РассчитатьСуммы(ТекущаяСтрока["ВалютнаяСумма"+ДтКт], ТекущаяСтрока["Валюта"+ДтКт], НаДату);
	ЗаполнитьЗначенияСвойств(ТекущаяСтрока, СуммыПроводки);
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция РассчитатьСуммы(ВалютнаяСумма, Валюта, НаДату)
	
	СуммыПроводки = Новый Структура("Сумма,СуммаПредставления",0,0);
	КоэффициентыПересчета = МеждународныйУчетОбщегоНазначения.ПолучитьКоэффициентыПересчетаВалюты(Валюта, НаДату);
	СуммыПроводки.Сумма = ВалютнаяСумма * КоэффициентыПересчета.ВФункциональнуюВалюту;
	СуммыПроводки.СуммаПредставления = ВалютнаяСумма * КоэффициентыПересчета.ВВалютуПредставления;
	
	Возврат СуммыПроводки;
	
КонецФункции

&НаСервере
Функция ОбоработкаВыбораШаблонаОперацииСервер(ШаблоныОперации)
	
	Текст = "";
	Если ТипЗнч(ШаблоныОперации) = Тип("СправочникСсылка.ТиповыеОперацииМеждународныйУчет") Тогда
		ЗагрузитьШаблонОперации(ШаблоныОперации);
		Текст = ШаблоныОперации.Наименование;
	ИначеЕсли ТипЗнч(ШаблоныОперации) = Тип("Массив") Тогда
		
		Для Каждого Шаблон Из ШаблоныОперации Цикл
			ЗагрузитьШаблонОперации(Шаблон);
			Если ПустаяСтрока(Текст) Тогда
				Текст = Шаблон.Наименование;
			Иначе
				Текст = Текст + "," + Символы.ПС + Шаблон.Наименование;
			КонецЕсли;
		КонецЦикла;
		
	КонецЕсли;
	
	Возврат Текст;
	
КонецФункции

&НаСервере
Процедура ЗагрузитьШаблонОперации(ШаблонОперации)
	
	Если Объект.Организация.Пустая() Тогда
		Объект.Организация = ШаблонОперации.Организация;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(Объект.СодержаниеОперации) Тогда
		Объект.СодержаниеОперации = ШаблонОперации.СодержаниеОперации;
	КонецЕсли;
	
	Для Каждого Проводка Из ШаблонОперации.Проводки Цикл
		
		НоваяПроводка = Объект.Движения.Международный.Добавить();
		ЗаполнитьЗначенияСвойств(НоваяПроводка, Проводка);
		НоваяПроводка.Активность = Ложь;
		НоваяПроводка.Период = Объект.Дата;
		
	КонецЦикла;
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПроводкиИзХранилища(АдресПроводокВХранилище)
	
	Объект.Движения.Международный.Загрузить(ПолучитьИзВременногоХранилища(АдресПроводокВХранилище));
	
КонецПроцедуры

&НаСервере
Функция ПредставлениеВидовСубконтоСчета(Счет, ДтКт)
	
	Возврат МеждународныйУчетОбщегоНазначения.ПредставлениеВидовСубконто(Счет, ДтКт);
	
КонецФункции

&НаКлиентеНаСервереБезКонтекста
Функция ПолучитьСписокПараметров(Форма, ТекущиеДанные, ДтКт)

	ШаблонИмяПоляОбъекта = "Субконто" + ДтКт + "%Индекс%";
	СписокПараметров = Новый Структура;
	Для Индекс = 1 По 3 Цикл
		ИмяПоля = СтрЗаменить(ШаблонИмяПоляОбъекта, "%Индекс%", Индекс);
		Если ТипЗнч(ТекущиеДанные[ИмяПоля]) = Тип("СправочникСсылка.Контрагенты") Тогда
			СписокПараметров.Вставить("Контрагент", ТекущиеДанные[ИмяПоля]);
			
		ИначеЕсли ТипЗнч(ТекущиеДанные[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКонтрагентов")
			ИЛИ ТипЗнч(ТекущиеДанные[ИмяПоля]) = Тип("СправочникСсылка.ДоговорыКредитовИДепозитов") Тогда
			СписокПараметров.Вставить("ДоговорКонтрагента", ТекущиеДанные[ИмяПоля]);
			
		ИначеЕсли ТипЗнч(ТекущиеДанные[ИмяПоля]) = Тип("СправочникСсылка.Номенклатура") Тогда
			СписокПараметров.Вставить("Номенклатура", ТекущиеДанные[ИмяПоля]);
			
		ИначеЕсли ТипЗнч(ТекущиеДанные[ИмяПоля]) = Тип("СправочникСсылка.Склады") Тогда
			СписокПараметров.Вставить("Склад", ТекущиеДанные[ИмяПоля]);
			
		КонецЕсли;
	КонецЦикла;
	СписокПараметров.Вставить("ОстаткиОбороты", ДтКт);
	СписокПараметров.Вставить("Организация"   , Форма.Объект.Организация);
	СписокПараметров.Вставить("СчетУчета"     , ТекущиеДанные["Счет"+ДтКт]);

	Возврат СписокПараметров;

КонецФункции

&НаСервере
Процедура ЗагрузитьПроводкиСторноНаСервере()
	
	ДокументыСторно = Объект.ЗаполнениеДвижений.Выгрузить(,"Документ");
	Если ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		НовыйДокумент = ДокументыСторно.Добавить();
		НовыйДокумент.Документ = СторнируемыйДокумент;
		ДокументыСторно.Свернуть("Документ");
	КонецЕсли;
	ЗагрузитьПроводкиДляСторнирования(ДокументыСторно);
	
КонецПроцедуры

&НаСервере
Процедура ЗагрузитьПроводкиДляСторнирования(Регистраторы)
	
	ПроводкиОперации = РегистрыБухгалтерии.Международный.ПроводкиСторно(Регистраторы, Объект.ВводитьПериодПоСтрокам);
	Объект.Движения.Международный.Загрузить(ПроводкиОперации);
	
КонецПроцедуры

&НаКлиенте
Процедура СторнируемыйДокументНажатие(Элемент, СтандартнаяОбработка)
	
	Если ТипЗнч(СторнируемыйДокумент) = Тип("Строка") Тогда
		
		СтандартнаяОбработка = Ложь;
		СписокТипов = Новый СписокЗначений;
		СписокТипов.ЗагрузитьЗначения(Элемент.ОграничениеТипа.Типы());
		СписокТипов.СортироватьПоЗначению();
		СписокТипов.Удалить(СписокТипов.НайтиПоЗначению(Тип("Строка")));
		СписокТипов.ПоказатьВыборЭлемента(Новый ОписаниеОповещения("ОбработчикВыбораТипаДокумента", ЭтотОбъект),
											НСтр("ru = 'Выберите тип:'"));
		
		
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ОбработчикВыбораТипаДокумента(ВыбранныйТип, ДополнительныеПараметры) Экспорт
	
	Если ВыбранныйТип <> Неопределено Тогда
		ИмяДокумента = ИмяТипа(ВыбранныйТип.Значение);
		ОткрытьФорму("Документ."+ИмяДокумента+".ФормаВыбора",,ЭтаФорма);
	КонецЕсли;
	
КонецПроцедуры

&НаСервереБезКонтекста
Функция ИмяТипа(ЗаданныйТип)
	
	Возврат Метаданные.НайтиПоТипу(ЗаданныйТип).Имя;
	
КонецФункции

&НаКлиенте
Процедура ПерейтиВСписок(Команда)
	
	ФлажокСписок = Истина;
	Элементы.СтраницыСторнирования.ТекущаяСтраница = Элементы.ГруппаСторнироватьСписок;
	Элементы.ГруппаСторнироватьСписок.Видимость = Истина;
	Если ЗначениеЗаполнено(СторнируемыйДокумент) И ТипЗнч(СторнируемыйДокумент) <> Тип("Строка") Тогда
		Объект.ЗаполнениеДвижений.Очистить();
		НоваяСтрока = Объект.ЗаполнениеДвижений.Добавить();
		НоваяСтрока.Документ = СторнируемыйДокумент;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиенте
Процедура ВыйтиИзСписка(Команда)
	
	ФлажокСписок = Ложь;
	Элементы.СтраницыСторнирования.ТекущаяСтраница = Элементы.ГруппаСторнироватьДокумент;
	Элементы.ГруппаСторнироватьСписок.Видимость = Ложь;
	Если Объект.ЗаполнениеДвижений.Количество() > 0 Тогда
		СторнируемыйДокумент = Объект.ЗаполнениеДвижений[0].Документ;
		Объект.ЗаполнениеДвижений.Очистить();
	ИначеЕсли Объект.ЗаполнениеДвижений.Количество() = 0 Тогда
		СторнируемыйДокумент = Неопределено;
	КонецЕсли;
	
	Если НЕ ЗначениеЗаполнено(СторнируемыйДокумент) Тогда
		СторнируемыйДокумент = ТекстВвестиДокумент;
	КонецЕсли;
	
КонецПроцедуры

&НаКлиентеНаСервереБезКонтекста
Процедура ИзменитьПараметрыВыбораПолейСубконто(Форма, ДтКт = "")
	
	ИдСтроки = Форма.Элементы.ДвиженияМеждународный.ТекущаяСтрока;
	Если ИдСтроки = Неопределено Тогда
		Возврат;
	КонецЕсли;
	СтрокаТаблицы = Форма.Объект.Движения.Международный.НайтиПоИдентификатору(ИдСтроки);
	ПараметрыДокумента = ПолучитьСписокПараметров(Форма, СтрокаТаблицы, ДтКт);
	ШаблонИмяПоляОбъекта = "Субконто"+ДтКт+"%Индекс%";
	ШаблонИмяЭлементаФормы = "Субконто"+ДтКт+"%Индекс%";
	
	ВидыПараметров = Новый Соответствие;
	ВидыПараметров.Вставить(Тип("СправочникСсылка.БанковскиеСчетаОрганизаций"), "БанковскийСчет");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.ДоговорыКонтрагентов"), "Договор");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.ДоговорыКредитовИДепозитов"), "Договор");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.ДоговорыЛизинга"), "Договор");
	ВидыПараметров.Вставить(Тип("СправочникСсылка.РегистрацииВНалоговомОргане"), "РегистрацияВИФНС");
	
	ОчищатьСвязанныеСубконто = Ложь;
	ТипыСвязанныхСубконто    = Неопределено;
	Если ТипЗнч(Форма.ТекущийЭлемент) = Тип("ТаблицаФормы") Тогда
		ТекущийЭлемент = Форма.ТекущийЭлемент.ТекущийЭлемент;
	Иначе
		ТекущийЭлемент = Форма.ТекущийЭлемент;
	КонецЕсли;
	ИмяТекущегоЭлемента = ?(ТипЗнч(ТекущийЭлемент) = Тип("ПолеФормы"), ТекущийЭлемент.Имя, "");
	
	Для Индекс = 1 По 3 Цикл
		ИмяЭлементаФормы = СтрЗаменить(ШаблонИмяЭлементаФормы, "%Индекс%", Индекс);
		ИмяПоляОбъекта   = СтрЗаменить(ШаблонИмяПоляОбъекта  , "%Индекс%", Индекс);
		ТипПоляОбъекта   = ТипЗнч(СтрокаТаблицы[ИмяПоляОбъекта]);
		
		ВидПараметра = ВидыПараметров[ТипПоляОбъекта];
		
		Если ВидПараметра <> Неопределено Тогда
			
			МассивПараметров = Новый Массив();
			Если ВидПараметра = "Договор" Тогда
				Если ПараметрыДокумента.Свойство("Организация") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Организация", ПараметрыДокумента.Организация));
				КонецЕсли;
				Если ПараметрыДокумента.Свойство("Контрагент") Тогда
					МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Контрагент", ПараметрыДокумента.Контрагент));
				КонецЕсли;
			ИначеЕсли ВидПараметра = "БанковскийСчет" Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", ПараметрыДокумента.Организация));
			ИначеЕсли ВидПараметра = "РегистрацияВИФНС" Тогда
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", 
					ОбщегоНазначенияБПВызовСервераПовтИсп.ГоловнаяОрганизация(ПараметрыДокумента.Организация)));
			ИначеЕсли ВидПараметра = "Субконто" И ПараметрыДокумента.Свойство("СчетУчета") Тогда
				СвойстваСчета = БухгалтерскийУчетВызовСервераПовтИсп.ПолучитьСвойстваСчета(ПараметрыДокумента.СчетУчета);
				МассивПараметров.Добавить(Новый ПараметрВыбора("Отбор.Владелец", СвойстваСчета["ВидСубконто" + Индекс]));
			КонецЕсли;
			
			Если МассивПараметров.Количество() > 0 Тогда
				ПараметрыВыбора = Новый ФиксированныйМассив(МассивПараметров);
				Форма.Элементы[ИмяЭлементаФормы].ПараметрыВыбора = ПараметрыВыбора;
			КонецЕсли;
			
		КонецЕсли;
		
		Если ОчищатьСвязанныеСубконто 
			И ЗначениеЗаполнено(СтрокаТаблицы[ИмяПоляОбъекта]) Тогда
		
			Если ТипыСвязанныхСубконто = Неопределено Тогда
				ВсеТипыСвязанныхСубконто = БухгалтерскийУчетВызовСервераПовтИсп.ВсеТипыСвязанныхСубконто();
				ТипыСвязанныхСубконто    = Новый ОписаниеТипов(Новый Массив);
				Для каждого Параметр Из ПараметрыДокумента Цикл
					Если ВсеТипыСвязанныхСубконто[Параметр.Ключ] <> Неопределено Тогда
						ТипыСвязанныхСубконто = Новый ОписаниеТипов(ТипыСвязанныхСубконто, 
							ВсеТипыСвязанныхСубконто[Параметр.Ключ].Типы());
					КонецЕсли;
				КонецЦикла;
			КонецЕсли;
			
			Если ТипыСвязанныхСубконто.СодержитТип(ТипПоляОбъекта) Тогда
				СтрокаТаблицы[ИмяПоляОбъекта] = Новый (ТипПоляОбъекта);
			КонецЕсли;
		
		КонецЕсли;
		
		Если ИмяТекущегоЭлемента = ИмяЭлементаФормы Тогда
			ОчищатьСвязанныеСубконто = Истина; // Очищаются только субконто с номером больше текущего
		КонецЕсли;
			
	КонецЦикла;

КонецПроцедуры

&НаКлиенте
Процедура ОчиститьПараметрыВыбора(Элемент)
	
	Элемент.ПараметрыВыбора = Новый ФиксированныйМассив(Новый Массив);
	
КонецПроцедуры

#КонецОбласти
