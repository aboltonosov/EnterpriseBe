﻿
#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;

	// Параметры формы
	ИнициализироватьПараметрыФормы(Параметры.ЗначенияЗаполнения);
	
	// Настройка элементов формы
	УстановитьНастройкиЭлементовФормы();
	
КонецПроцедуры

&НаКлиенте
Процедура ПриОткрытии(Отказ)
	
	УстановитьДоступностьЭлементов();
	УстановитьПодсказкуДляПоляУказатьНовоеКоличество();
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиСобытийЭлементовФормы

&НаКлиенте
Процедура РежимСокращенияПриИзменении(Элемент)
	
	НовоеКоличество = КоличествоЗапланировано;
	ПересчитатьИтогиПриИзмененииКоличества();
	
КонецПроцедуры

&НаКлиенте
Процедура НовоеКоличествоПриИзменении(Элемент)
	
	ПересчитатьИтогиПриИзмененииКоличества();
	
КонецПроцедуры

&НаКлиенте
Процедура НовоеКоличествоРегулирование(Элемент, Направление, СтандартнаяОбработка)
	
	СтандартнаяОбработка = Ложь;

	ЗначениеРегулирования = НовоеКоличество + Направление*КратностьВыпуска;
	
	Если ЗначениеРегулирования >= Элемент.МинимальноеЗначение И ЗначениеРегулирования <= Элемент.МаксимальноеЗначение Тогда
		
		НовоеКоличество = ЗначениеРегулирования; 
		
		ПересчитатьИтогиПриИзмененииКоличества();
		
	КонецЕсли;
	
КонецПроцедуры

#КонецОбласти

#Область ОбработчикиКомандФормы

&НаКлиенте
Процедура Выбрать(Команда)
	
	Если РежимСокращения = 0 Тогда
		
		ПоказатьПредупреждение(, НСтр("ru = 'Необходимо выбрать способ сокращения производства.'"));
		Возврат;
		
	ИначеЕсли РежимСокращения = 2 И НовоеКоличество % КратностьВыпуска <> 0 Тогда
		
		ТекстПредупреждения = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Количество производимого изделия должно быть кратно %1.'"),
			КратностьВыпуска
		);
		
		ПоказатьПредупреждение(, ТекстПредупреждения);
		Возврат;
		
	ИначеЕсли РежимСокращения = 2 И НовоеКоличество = КоличествоЗапланировано Тогда
		
		ЭтаФорма.Закрыть();
		Возврат;
		
	КонецЕсли;
	
	ПараметрыСокращения = Новый Структура;
	
	ПараметрыСокращения.Вставить("Заказ", Заказ);
	ПараметрыСокращения.Вставить("КлючСвязиПродукция", КлючСвязиПродукция);
	ПараметрыСокращения.Вставить("КлючСвязиПолуфабрикат", КлючСвязиПолуфабрикат);

	Если РежимСокращения = 1 Тогда
		
		ПараметрыСокращения.Вставить("НовоеКоличество", Макс(КоличествоТребуется, КоличествоВыполнено + КоличествоВыполняетсяСУчетомПолуфабрикатов));
		
	ИначеЕсли РежимСокращения = 2 Тогда
		
		ПараметрыСокращения.Вставить("НовоеКоличество", НовоеКоличество);
		
	ИначеЕсли РежимСокращения = 3 Тогда

		ПараметрыСокращения.Вставить("НовоеКоличество", Макс(КоличествоТребуется, КоличествоВыполнено + КоличествоВыполняется));
		
	КонецЕсли;
	
	ПараметрыСокращения.Вставить("ДоделатьНачатыеПолуфабрикаты", Истина);
	
	Если ЭтоПродукция Тогда
		ПараметрыСокращения.Вставить("КоличествоТребуется", ПараметрыСокращения.НовоеКоличество);
		ПараметрыСокращения.Вставить("БезопасноеСокращение", КоличествоВыполнено + КоличествоВыполняетсяСУчетомПолуфабрикатов);
	Иначе
		ПараметрыСокращения.Вставить("КоличествоТребуется", КоличествоТребуется);
		ПараметрыСокращения.Вставить("БезопасноеСокращение", 0);
	КонецЕсли;
	
	ВыбранноеДействие = Новый Структура;
	ВыбранноеДействие.Вставить("Действие", "СократитьПроизводство");
	ВыбранноеДействие.Вставить("Параметры", ПараметрыСокращения);
	
	ОповеститьОВыборе(ВыбранноеДействие);
	
КонецПроцедуры

#КонецОбласти

#Область Прочее

&НаСервере
Процедура ИнициализироватьПараметрыФормы(Параметры)
	
	ПустойКлюч = Новый УникальныйИдентификатор("00000000-0000-0000-0000-000000000000");
	СвойстваИсключения = "";
	
	Заголовок = Параметры.Заголовок;
	АдресДанных = Параметры.АдресДанных;
	Показатели = Параметры.Показатели;
	СтруктураПоиска = Параметры.СтруктураПоиска;
	
	СтруктураДанных = ПолучитьИзВременногоХранилища(АдресДанных);
	
	ДанныеИзделия = СтруктураДанных.ВыходныеИзделия.НайтиСтроки(СтруктураПоиска)[0];
	
	ЭтоПродукция = (ДанныеИзделия.КлючСвязиПолуфабрикат = ПустойКлюч);
	
	//Ключевые данные
	Заказ = ДанныеИзделия.Заказ;
	КлючСвязиПродукция = ДанныеИзделия.КлючСвязиПродукция;
	КлючСвязиПолуфабрикат = ДанныеИзделия.КлючСвязиПолуфабрикат;
	
	// Продукция, полуфабрикат
	Если ЭтоПродукция Тогда 
		
		Продукция = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
			ДанныеИзделия.НоменклатураПредставление,
			ДанныеИзделия.ХарактеристикаПредставление);
			
		СвойстваИсключения = "КоличествоТребуется";
			
	Иначе
		
		СтруктураОтбора = ОбщегоНазначенияКлиентСервер.СкопироватьСтруктуру(СтруктураПоиска);
		СтруктураОтбора.Вставить("КлючСвязиПолуфабрикат", ПустойКлюч); 
		
		ДанныеПродукции = СтруктураДанных.ВыходныеИзделия.НайтиСтроки(СтруктураОтбора)[0];
		
		Продукция = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
			ДанныеПродукции.НоменклатураПредставление,
			ДанныеПродукции.ХарактеристикаПредставление);
			
		Полуфабрикат = НоменклатураКлиентСервер.ПредставлениеНоменклатуры(
			ДанныеИзделия.НоменклатураПредставление,
			ДанныеИзделия.ХарактеристикаПредставление);
		
	КонецЕсли;
	
	// Количественные показатели
	ЗаполнитьЗначенияСвойств(ЭтаФорма, Показатели,, СвойстваИсключения);
	
	// Единица измерения
	ЕдиницаИзмерения = ДанныеИзделия.ЕдиницаИзмерения;
	КратностьВыпуска = ДанныеИзделия.ВыходныхИзделийНаОдинЭтап;
	
	НовоеКоличество = КоличествоЗапланировано;
	КоличествоВыполняетсяПолуфабрикатов = КоличествоВыполняетсяСУчетомПолуфабрикатов - КоличествоВыполняется;
	
КонецПроцедуры

&НаСервере
Процедура УстановитьНастройкиЭлементовФормы()
	
	ЭтоПолуфабрикат = Не ЭтоПродукция;
	
	КоличествоВыполненоИВыполняется = КоличествоВыполнено + КоличествоВыполняется;
	КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов = КоличествоВыполнено + КоличествоВыполняетсяСУчетомПолуфабрикатов;
	
	// установим видимость/доступность элементов формы
	Элементы.Полуфабрикат.Видимость = ЭтоПолуфабрикат;
	Элементы.КоличествоТребуется.Видимость = ЭтоПолуфабрикат;
	Элементы.КоличествоИзлишек.Видимость = ЭтоПолуфабрикат;
	
	#Область ПроизвестиНачатое
	ГруппаПроизвестиНачатоеДоступна = Ложь;
	
	Если КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов > Макс(КоличествоЗапланировано, КоличествоТребуется) Тогда
		
		ГруппаПроизвестиНачатоеДоступна = Истина;
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Произвести %1 %2 изделия.'"),
			КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов,
			ЕдиницаИзмерения
		);
		
	ИначеЕсли КоличествоЗапланировано = 0 Тогда
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = НСтр("ru = 'Отменить неначатое невозможно, т.к. производство не запланировано.'");
		
	ИначеЕсли КоличествоЗапланировано = КоличествоВыполнено Тогда
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = НСтр("ru = 'Отменить неначатое невозможно, т.к. завершено производство всего запланированного количества.'");
		
	ИначеЕсли ЭтоПолуфабрикат И КоличествоТребуется = КоличествоЗапланировано Тогда
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = НСтр("ru = 'Отменить неначатое невозможно, т.к. для следующих этапов требуется производство всего запланированного количества.'");
		
	ИначеЕсли КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов = КоличествоЗапланировано Тогда
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = НСтр("ru = 'Отменить неначатое невозможно, т.к. начато производство всего запланированного количества.'");
		
	Иначе
		
		ГруппаПроизвестиНачатоеДоступна = Истина;
		
		Элементы.ГруппаПроизвестиНачатое.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Произвести %1 %3 изделия и отменить производство %2 %3 изделия.'"),
			Макс(КоличествоТребуется, КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов),
			КоличествоЗапланировано - Макс(КоличествоТребуется, КоличествоВыполненоИВыполняетсяСУчетомПолуфабрикатов),
			ЕдиницаИзмерения
		);
		
	КонецЕсли;
	
	Элементы.ГруппаПроизвестиНачатое.Доступность = ГруппаПроизвестиНачатоеДоступна;
	
	#КонецОбласти
	
	#Область НовоеКоличество
	
	Если ЭтоПродукция Тогда
		Элементы.НовоеКоличество.МинимальноеЗначение = КоличествоВыполненоИВыполняется;
	Иначе
		Элементы.НовоеКоличество.МинимальноеЗначение = Макс(КоличествоВыполненоИВыполняется, КоличествоТребуется);
	КонецЕсли;
	
	Элементы.НовоеКоличество.МаксимальноеЗначение = КоличествоПоЗаказу;
	
	#КонецОбласти
	
	#Область ОстановитьВсе
	ГруппаОставитьВсеДоступна = Ложь;
	
	Если (КоличествоОсталось - КоличествоВыполняется) > Макс(КоличествоТребуется - КоличествоВыполнено, 0) Тогда
		
		ГруппаОставитьВсеДоступна = Истина;
		
		Если КоличествоЗапланировано - Макс(КоличествоТребуется, КоличествоВыполненоИВыполняется) > КоличествоВыполняетсяСУчетомПолуфабрикатов Тогда
			
			ТекстШаблон = НСтр("ru = 'Отменить производство %1 %2 изделия, доделав начатые полуфабрикаты.'");
			
		Иначе
			
			ТекстШаблон = НСтр("ru = 'Отменить производство %1 %2 изделия.'");
			
		КонецЕсли;
		
		Элементы.ГруппаОстановитьВсе.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстШаблон,
			КоличествоЗапланировано - Макс(КоличествоТребуется, КоличествоВыполненоИВыполняется),
			ЕдиницаИзмерения
		);
		
	ИначеЕсли КоличествоЗапланировано = 0 Тогда
		
		Элементы.ГруппаОстановитьВсе.Подсказка = НСтр("ru = 'Остановить невозможно, т.к. производство не запланировано.'");
		
	ИначеЕсли КоличествоЗапланировано = КоличествоВыполнено Тогда
		
		Элементы.ГруппаОстановитьВсе.Подсказка = НСтр("ru = 'Остановить невозможно, т.к. завершено производство всего запланированного количества.'");
		
	ИначеЕсли ЭтоПолуфабрикат И КоличествоТребуется = КоличествоЗапланировано Тогда
		
		Элементы.ГруппаОстановитьВсе.Подсказка = НСтр("ru = 'Остановить невозможно, т.к. для следующих этапов требуется производство всего запланированного количества.'");
		
	ИначеЕсли КоличествоВыполненоИВыполняется = КоличествоЗапланировано Тогда
		
		Элементы.ГруппаОстановитьВсе.Подсказка = НСтр("ru = 'Остановить невозможно, т.к. начато производство всего запланированного количества.'");
		
	КонецЕсли;
	
	Элементы.ГруппаОстановитьВсе.Доступность = ГруппаОставитьВсеДоступна;
	
	#КонецОбласти
	
	#Область Подсказки
	
	// установим подсказку поля "количество требуется"
	Элементы.КоличествоТребуется.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
		НСтр("ru = 'Для следующих этапов требуется производство %1 %2 изделия.'"),
		КоличествоТребуется,
		ЕдиницаИзмерения
	);
	
	Если ЭтоПродукция = Ложь Тогда
		
		// подсказка поля "количество осталось"
		Элементы.КоличествоОсталось.Подсказка = "f(x) = Запланировано - Выполнено";
		
		// подсказка поля "количество излишек"
		Элементы.КоличествоИзлишек.Подсказка = "f(x) = Выполнено + Осталось - Требуется";
		
	КонецЕсли;
	
	#КонецОбласти
	
	#Область Примечание 
	
	// установим примечание "выполняется"
	Если КоличествоВыполняется > 0 Тогда
		
		Элементы.ГруппаПримечаниеВыполняется.Видимость = Истина;
		
		Элементы.ТекстВыполняется.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Производится %1 %2 изделия.'"),
			КоличествоВыполняется,
			ЕдиницаИзмерения
		);
		
	Иначе
		
		Элементы.ГруппаПримечаниеВыполняется.Видимость = Ложь;
		
	КонецЕсли;
	
	// установим примечание "выполняется (с учетом полуфабрикатов)"
	Если КоличествоВыполняетсяПолуфабрикатов > 0 Тогда
		
		Элементы.ГруппаПримечаниеВыполняетсяСУчетомПолуфабрикатов.Видимость = Истина;
		
		Элементы.ТекстВыполняетсяСУчетомПолуфабрикатов.Заголовок = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Начато производство полуфабрикатов для %1 %2 изделия.'"),
			КоличествоВыполняетсяПолуфабрикатов,
			ЕдиницаИзмерения
		);
		
	Иначе
		
		Элементы.ГруппаПримечаниеВыполняетсяСУчетомПолуфабрикатов.Видимость = Ложь;
		
	КонецЕсли;
	
	#КонецОбласти
	
	РежимСокращения = ?(Элементы.ГруппаПроизвестиНачатое.Доступность, 1, 2);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьДоступностьЭлементов()
	
	// установим доступность группы "Указать новое количество"
	Элементы.ГруппаНовоеКоличество.Доступность = (РежимСокращения = 2);
	
КонецПроцедуры

&НаКлиенте
Процедура УстановитьПодсказкуДляПоляУказатьНовоеКоличество()
	
	Если НовоеКоличество > КоличествоЗапланировано Тогда
		
		Элементы.ГруппаУказатьНовоеКоличество.Подсказка = НСтр("ru = 'Увеличить количество производимого изделия.'");
		
	ИначеЕсли НовоеКоличество = КоличествоЗапланировано Тогда
		
		Если ЭтоПродукция = Ложь И КоличествоТребуется > КоличествоВыполнено + КоличествоВыполняется Тогда
			
			ТекстШаблон = НСтр("ru = '%1 (требуемое)'");
			
		ИначеЕсли КоличествоВыполняется > 0 Тогда
			
			ТекстШаблон = НСтр("ru = '%1 (выполняемое)'");
			
		ИначеЕсли КоличествоВыполнено > 0 Тогда
			
			ТекстШаблон = НСтр("ru = '%1 (выполненное)'");
			
		Иначе
			
			ТекстШаблон = НСтр("ru = '%1'");
			
		КонецЕсли;
		
		ТекстМинимальноеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			ТекстШаблон,
			Элементы.НовоеКоличество.МинимальноеЗначение
		);

		ТекстМаксимальноеЗначение = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = '%1 (исходное)'"),
			Элементы.НовоеКоличество.МаксимальноеЗначение
		);

		Элементы.ГруппаУказатьНовоеКоличество.Подсказка = СтроковыеФункцииКлиентСервер.ПодставитьПараметрыВСтроку(
			НСтр("ru = 'Запланировать производство изделия в количество от %1 до %2 %3.'"),
			ТекстМинимальноеЗначение,
			ТекстМаксимальноеЗначение,
			ЕдиницаИзмерения
		);
		
	ИначеЕсли НовоеКоличество < КоличествоЗапланировано И КоличествоОсталось < КоличествоВыполняетсяСУчетомПолуфабрикатов Тогда
		
		Элементы.ГруппаУказатьНовоеКоличество.Подсказка = НСтр("ru = 'Уменьшить, доделав начатые полуфабрикаты.'");
		
	Иначе
	
		Элементы.ГруппаУказатьНовоеКоличество.Подсказка = НСтр("ru = 'Уменьшить количество производимого изделия.'");
		
	КонецЕсли;
		
КонецПроцедуры

&НаКлиенте
Процедура ПересчитатьИтогиПриИзмененииКоличества()
	
	КоличествоОсталось = НовоеКоличество - КоличествоВыполнено;
	КоличествоИзлишек = КоличествоВыполнено + КоличествоОсталось - КоличествоТребуется;
	
	УстановитьДоступностьЭлементов();
	УстановитьПодсказкуДляПоляУказатьНовоеКоличество();
	
КонецПроцедуры

#КонецОбласти

